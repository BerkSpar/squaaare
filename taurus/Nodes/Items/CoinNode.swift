//
//  CoinNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class CoinNode: ItemNode {
    override func draw() {
        let node = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        node.fillColor = .yellow
        node.strokeColor = .yellow
        
        addChild(node)
    }
    
    override func configureCollision() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        physicsBody?.categoryBitMask = PhysicsCategory.coin
        
        super.configureCollision()
    }
    
    override func didContact(_ scene: GameScene) {
        removeFromParent()
        GameController.shared.points += 1
        scene.updatePoints()
    }
}
