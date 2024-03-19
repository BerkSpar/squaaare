//
//  AudioService.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import Foundation
import AVFAudio

class AudioService {
    var audioPlayer: AVAudioPlayer?
    
    init() { }
    
    func playAudio(withPath path: String) {
        guard let url = URL(string: path) else {
            print("Invalid path provided.")
            return
        }
        
        // Configure the audio session for playback
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            print("Tempo: \(audioPlayer?.duration.description ?? "sem tempo")")
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to initialize audio player with error: \(error.localizedDescription)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
    }
    
    func downloadSound(from url: URL, to destinationPath: URL, completion: @escaping (Error?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let tempURL = tempURL else {
                completion(NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid temporary URL"]))
                return
            }
            
            do {
                if FileManager.default.fileExists(atPath: destinationPath.path) {
                    try FileManager.default.removeItem(at: destinationPath)
                }
                
                try FileManager.default.moveItem(at: tempURL, to: destinationPath)
                completion(nil)
            } catch {
                completion(error)
            }
        }
        
        task.resume()
    }
}

