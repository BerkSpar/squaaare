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
    @Published var nextLevel = 100
    
    func canGoNextLevel() -> Bool {
        if points >= nextLevel {
            nextLevel += 100
            return true
        }
        
        return false
    }
    
    func reset() {
        points = 0
        nextLevel = 100
        oneMoreChance = true
    }
    
    func save() {
        let savedPoints = points
        GameService.shared.submitScore(savedPoints, ids: ["global_2", "daily_2"]) {
            Analytics.logEvent(AnalyticsEventPostScore, parameters: [
                AnalyticsParameterScore: savedPoints
            ])
        }
        
        GameController.shared.reset()
    }
}
