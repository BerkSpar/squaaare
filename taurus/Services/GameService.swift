//
//  GameService.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import Foundation
import GameKit

/// A service responsible for managing Game Center functionalities such as player authentication,
/// rewarding achievements, and controlling the access point's visibility.
///
/// This class provides a centralized way to interact with Game Center functionalities and
/// manage the Game Center experience for the user.
class GameService {
    
    /// The shared singleton instance of `GameService`.
    static let shared = GameService()
    
    /// Represents the local player instance from GameKit, which will be used for authentication.
    let player = GKLocalPlayer.local
    
    /// Authenticates the local player using Game Center.
    ///
    /// This function attempts to authenticate the local player with the Game Center. Upon completion, the provided
    /// completion handler will be called with an optional error string.
    ///
    /// If the authentication is successful, the completion handler is called with `nil`. If there's an error, the
    /// localized description of the error is passed to the completion handler.
    ///
    /// - Parameter completion: The callback to execute once authentication is completed. It takes an optional string
    ///                         as its parameter, representing a potential error.
    func authenticate(_ completion: @escaping (_ error: String?) -> Void?) {
        player.authenticateHandler = { vc, error in
            if (vc != nil) {
                return;
            }
            
            guard error == nil else {
                completion(error?.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
    
    /// Rewards an achievement to the player based on the provided identifier.
    ///
    /// The achievement will be marked as 100% complete and will display a completion banner.
    ///
    /// - Parameter identifier: The unique identifier of the achievement to be rewarded.
    func rewardAchievement(_ identifier: String) {
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement])
    }
    
    func reportAchievement(identifier: String, progress: Double) {
        guard progress > 0 else { return }  // Evitar progresso negativo ou zero
        
        let achievement = GKAchievement(identifier: identifier)
        
        // Buscar o progresso atual
        GKAchievement.loadAchievements { (achievements, error) in
            guard error == nil else {
                print("Erro ao carregar achievements:", error!)
                return
            }
            
            let currentAchievement = achievements?.first { $0.identifier == identifier }
            let currentProgress = currentAchievement?.percentComplete ?? 0.0
            
            // Calcula o novo progresso
            let newProgress = currentProgress + progress
            achievement.percentComplete = newProgress
            achievement.showsCompletionBanner = true
            
            // Tratamento para evitar que fique preso em 99%
            if newProgress >= 99 && newProgress < 100.0 {
                achievement.percentComplete = 100.0
            }
            
            GKAchievement.report([achievement]) { error in
                if let error = error {
                    print("Erro ao reportar achievement:", error)
                }
            }
        }
    }
    
    /// Resets all the achievements for the player.
    ///
    /// This function will reset all achievements back to their initial, unearned state.
    func resetAchievements() {
        GKAchievement.resetAchievements()
    }
    
    /// Hides the Game Center access point.
    ///
    /// This function deactivates the Game Center access point, making it hidden.
    func hideAccessPoint() {
        GKAccessPoint.shared.isActive = false
    }
    
    /// Shows the Game Center access point.
    ///
    /// This function activates the Game Center access point, making it visible.
    func showAccessPoint() {
        GKAccessPoint.shared.isActive = true
    }
    
    func showAchievements() {
        GKAccessPoint.shared.trigger(state: .achievements) {
            print("Acessou os achievements")
        }
    }
    
    func showLeaderboard() {
        GKAccessPoint.shared.trigger(state: .leaderboards) {
            print("Acessou os leaderboard")
        }
    }
    
    func submitScore(_ score: Int, ids: [String], completion: @escaping () -> Void?) {
        if player.isAuthenticated {
            GKLeaderboard.submitScore(score, context: 0, player: player, leaderboardIDs: ids) { error in
                completion()
            }
        }
    }
}
