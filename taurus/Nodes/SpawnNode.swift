//
//  SpawnNode.swift
//  taurus
//
//  Created by Felipe Passos on 24/03/24.
//

import SpriteKit

class SpawnNode: SKNode {
    let items: [Item] = [
        CoinNode(spawnTimeRange: 1...2, levelRange: 0...20, pointsRange: 1...3, velocityRange: 4...6),
        CoinNode(spawnTimeRange: 1...2, levelRange: 21...Int.max, pointsRange: 1...9, velocityRange: 2...4),
        
        EnemyNode(spawnTimeRange: 2...4, levelRange: 5...15, velocityRange: 8...12),
        EnemyNode(spawnTimeRange: 4...4, levelRange: 16...30, velocityRange: 4...8),
        EnemyNode(spawnTimeRange: 2...4, levelRange: 31...Int.max, velocityRange: 2...6)
    ]
    
    private var refreshRate = 0.5
    private var nextUpdate: [String: TimeInterval] = [:]
    private var lastUpdate: [String: TimeInterval] = [:]
    
    private func spawn(_ item: Item, _ scene: GameScene) {
        let level = GameController.shared.points
        
        if nextUpdate[item.id] == nil {
            nextUpdate[item.id] = Double.random(in: item.spawnTimeRange)
        }
        
        if lastUpdate[item.id] == nil {
            lastUpdate[item.id] = 0
        } else {
            lastUpdate[item.id]! += refreshRate
        }
            
        if lastUpdate[item.id]! < nextUpdate[item.id]! { return }
        if !item.levelRange.contains(level) { return }
        
        let clone = item.clone()
        clone.draw()
        clone.configureCollision()
        clone.spawn(scene)
        
        nextUpdate[item.id] = Double.random(in: item.spawnTimeRange)
        lastUpdate[item.id] = 0
    }
    
    func start(_ scene: GameScene) {
        for item in items {
            run(.repeatForever(.sequence([
                .wait(forDuration: refreshRate),
                .run {
                    self.spawn(item, scene)
                }
            ])))
        }
    }
    
    func stop() {
        removeAllActions()
    }
}
