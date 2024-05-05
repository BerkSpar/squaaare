//
//  PlayerDataManager.swift
//  ColorDefender
//
//  Created by André Wozniack on 01/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Network

struct PlayerData: Codable {
    var highscore: Int = 0
    var coins: Int = 0
    var blueCoins: Int = 0
    var skins: [String] = ["basic"]
    
    var bombs: Int = 0
    var portals: Int = 0
    var shields: Int = 0
    
    var showAds: Bool = true
}

public class PlayerDataManager {
    
    static let shared = PlayerDataManager()
    
    private let db = Firestore.firestore()
    
    private var networkMonitor: NWPathMonitor?
    
    var playerData: PlayerData
    
    private init() {
        self.playerData = PlayerData()
        
        if let loadedData = self.loadLocalPlayerData() {
            self.playerData = loadedData
        }
        
        self.startObservingPlayerDataChanges()
    }
    
    
    func setPlayerData() {
        saveLocalPlayerData()
        savePlayerDataToFirestore { success in
            print("Dados salvos no Firestore: \(success ? "Sucesso" : "Falha")")
        }
    }
    
    func saveLocalPlayerData() {
        do {
            let data = try JSONEncoder().encode(playerData)
            UserDefaults.standard.set(data, forKey: "playerData")
        } catch {
            print("Erro ao salvar os dados do jogador localmente: \(error)")
        }
    }
    
    func loadLocalPlayerData() -> PlayerData? {
        guard let data = UserDefaults.standard.data(forKey: "playerData") else { return nil }
        do {
            return try JSONDecoder().decode(PlayerData.self, from: data)
        } catch {
            print("Erro ao carregar os dados do jogador localmente: \(error)")
            return nil
        }
    }
    
    func savePlayerDataToFirestore(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Usuário não está logado.")
            completion(false)
            return
        }
        
        do {
            let data = try JSONEncoder().encode(playerData)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
            db.collection("players").document(userId).setData(dictionary) { error in
                if let error = error {
                    print("Erro ao salvar os dados do jogador no Firestore: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("Erro ao codificar PlayerData: \(error)")
            completion(false)
        }
    }
    
    func loadPlayerDataFromFirestore(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Usuário não está logado.")
            completion(false)
            return
        }
        
        db.collection("players").document(userId).getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    self.playerData = try JSONDecoder().decode(PlayerData.self, from: jsonData)
                    self.saveLocalPlayerData()

                    completion(true)
                } catch {
                    print("Erro ao decodificar os dados do Firestore para PlayerData: \(error)")
                    completion(false)
                }
            } else {
                print("Documento não encontrado ou erro ao acessar o Firestore: \(String(describing: error))")
                completion(false)
            }
        }
    }
    
    func synchronizeData() {
        loadPlayerDataFromFirestore { success in
            if !success {
                let player = self.loadLocalPlayerData()
                DispatchQueue.main.async {
                    GameService.shared.data = player ?? PlayerData()
                }
            }
        }
    }
    
    func startObservingPlayerDataChanges() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Usuário não está logado.")
            return
        }

        db.collection("players").document(userId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Erro ao observar mudanças nos dados do jogador: \(error?.localizedDescription ?? "Desconhecido")")
                return
            }
            
            guard let data = document.data() else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                self.playerData = try JSONDecoder().decode(PlayerData.self, from: jsonData)
                self.saveLocalPlayerData()
            } catch {
                print("Erro ao decodificar os dados atualizados do Firestore para PlayerData: \(error)")
            }
        }
    }
    
    func startMonitoringNetwork() {
        stopMonitoringNetwork()
        networkMonitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor?.start(queue: queue)

        networkMonitor?.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Conectado à internet. Tentando sincronizar dados pendentes...")
                DispatchQueue.main.async {
                    self?.synchronizeData()
                }
            } else {
                print("Não está conectado à internet.")
            }
        }
    }

    func stopMonitoringNetwork() {
        networkMonitor?.cancel()
        networkMonitor = nil
    }
}
