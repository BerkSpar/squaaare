//
//  SpawnNode.swift
//  taurus
//
//  Created by Felipe Passos on 24/03/24.
//

import SpriteKit

class SpawnNode: SKNode {
    let items: [Item] = [
        CoinNode(spawnTimeRange: 1...2, levelRange: 0...100, pointsRange: 4...7, velocityRange: 4...6),
        CoinNode(spawnTimeRange: 2...4, levelRange: 101...Int.max, pointsRange: 5...9, velocityRange: 2...4),

        EnemyNode(spawnTimeRange: 4...8, levelRange: 0...50, velocityRange: 8...12),
        EnemyNode(spawnTimeRange: 4...8, levelRange: 51...100, velocityRange: 6...10),
        EnemyNode(spawnTimeRange: 6...8, levelRange: 101...150, velocityRange: 4...8),
        EnemyNode(spawnTimeRange: 6...8, levelRange: 151...Int.max, velocityRange: 2...4),
        
        BombNode(spawnTimeRange: 30...40, levelRange: 201...400, velocityRange: 4...6),
        BombNode(spawnTimeRange: 20...30, levelRange: 401...600, velocityRange: 4...6),
        BombNode(spawnTimeRange: 10...20, levelRange: 600...Int.max, velocityRange: 4...6),
        
        DashNode(spawnTimeRange: 15...30, levelRange: 150...350, voltar: false),
        DashNode(spawnTimeRange: 10...20, levelRange: 351...500, voltar: false),
        DashNode(spawnTimeRange: 15...30, levelRange: 501...Int.max, voltar: true),
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
    
    func stop(_ scene: GameScene) {
        for child in scene.children {
            if child is Item {
                child.run(.sequence([
                    .fadeOut(withDuration: 0.5),
                    .removeFromParent()
                ]))
            }
        }
        
        removeAllActions()
    }
}
