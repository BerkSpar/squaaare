//
//  EnemyNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class EnemyNode: ItemNode {
    override func getVelocity() -> Double {
        Double.random(in: 4...8)
    }
    
    override func draw() {
        let node = SKSpriteNode(imageNamed: "basic_enemy")
        node.size = CGSize(width: 40, height: 40)
        
        addChild(node)
    }
    
    override func configureCollision() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        super.configureCollision()
    }
    
    override func didContact(_ scene: SKScene, _ contact: SKPhysicsContact) {
        HapticsService.shared.notify(.error)
        RouterService.shared.navigate(.endGame)
    }
}
