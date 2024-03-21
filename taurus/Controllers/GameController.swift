//
//  GameController.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SwiftUI

class GameController: ObservableObject {
    static let shared = GameController()
    
    @Published var points: Int = 0
    
    func reset() {
        points = 0
    }
    
    func save() {
        GameService.shared.submitScore(points, ids: ["global", "daily"]) {
            GameController.shared.reset()
        }
    }
}
