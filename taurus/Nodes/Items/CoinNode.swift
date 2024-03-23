//
//  CoinNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class CoinNode: ItemNode {
    let points = Int.random(in: 1...3)
    
    override func draw() {
        let node = SKSpriteNode(imageNamed: "coin")
        node.size = CGSize(width: 30, height: 30)
        
        addChild(node)
        
        let label = SKLabelNode(text: points.formatted())
        label.fontColor = .primary
        label.fontName = "Modak"
        label.fontColor = .mostard
        label.fontSize = 18
        label.position.y -= 7
        
        node.addChild(label)
    }
    
    override func configureCollision() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        physicsBody?.categoryBitMask = PhysicsCategory.coin
        
        super.configureCollision()
    }
    
    override func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let label = SKLabelNode(text: "+\(points)")
        label.position = contact.contactPoint
        label.fontColor = .primary
        label.fontName = "Modak"
        label.fontColor = .mostard
        
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
