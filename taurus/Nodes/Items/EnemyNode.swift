//
//  EnemyNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class EnemyNode: ItemNode {
    override func draw() {
        let node = SKShapeNode(ellipseOf: CGSize(width: 15, height: 15))
        node.fillColor = .red
        node.strokeColor = .red
        
        addChild(node)
    }
    
    override func configureCollision() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 15, height: 15))
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        super.configureCollision()
    }
    
    override func didContact(_ scene: SKScene, _ contact: SKPhysicsContact) {
        HapticsService.shared.notify(.error)
        RouterService.shared.navigate(.endGame)
    }
}
