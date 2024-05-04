//
//  GameController.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SwiftUI
import FirebaseAnalytics

class GameController: ObservableObject {
    static let shared = GameController()
    
    @Published var points: Int = 0
    @Published var oneMoreChance: Bool = true
    @Published var nextLevel = 50
    
    func canGoNextLevel() -> Bool {
        if points >= nextLevel {
            nextLevel += 50
            return true
        }
        
        return false
    }
    
    func reset() {
        points = 0
        nextLevel = 50
        oneMoreChance = true
    }
    
    func save() {
        submitScore()
        
        GameController.shared.reset()
    }
    
    func submitScore() {
        let savedPoints = points
        GameService.shared.submitScore(savedPoints, ids: ["global_2", "daily_2"]) {
            Analytics.logEvent(AnalyticsEventPostScore, parameters: [
                AnalyticsParameterScore: savedPoints
            ])
        }
        
        PlayerDataManager.shared.playerData.coins += points
        if PlayerDataManager.shared.playerData.highscore < points {
            PlayerDataManager.shared.playerData.highscore = points
        }
        
        PlayerDataManager.shared.setPlayerData()
    }
}
