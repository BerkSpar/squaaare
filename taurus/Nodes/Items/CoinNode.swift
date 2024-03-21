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
    
    override func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let points = Int.random(in: 1...3)
        
        let label = SKLabelNode(text: "+\(points)")
        label.position = contact.contactPoint
        scene.addChild(label)
        
        label.run(.sequence([
            .group([
                .fadeOut(withDuration: 1),
                .move(by: CGVector(dx: 0, dy: 20), duration: 1)
            ]),
            .removeFromParent()
        ]))
        
        GameController.shared.points += points
        scene.updatePoints()
        
        HapticsService.shared.play(.soft)
        
        removeFromParent()
    }
}
