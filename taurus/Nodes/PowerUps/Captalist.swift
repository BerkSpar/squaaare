//
//  Captalist.swift
//  taurus
//
//  Created by Felipe Passos on 07/04/24.
//

import SpriteKit

class Captalist: SKNode, Contactable {
    override init() {
        super.init()
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() {
        let circle = SKShapeNode(circleOfRadius: 80)
        circle.name = "captalist"
        circle.strokeColor = .mostard
        circle.lineWidth = 5
        circle.setScale(0)
        circle.alpha = 0.5
        
        circle.run(.repeatForever(.sequence([
            .scale(to: 1, duration: 1),
            .scale(to: 0, duration: 1)
        ])))
        
        let circle2 = SKShapeNode(circleOfRadius: 80)
        circle2.name = "captalist"
        circle2.strokeColor = .mostard
        circle2.lineWidth = 5
        circle2.setScale(0)
        circle2.alpha = 0.5
        
        circle2.run(.repeatForever(.sequence([
            .scale(to: 1, duration: 0.9),
            .scale(to: 0, duration: 0.9)
        ])))
        
        addChild(circle2)
        addChild(circle)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 80)
        physicsBody?.categoryBitMask = PhysicsCategory.coin
        
        physicsBody?.contactTestBitMask = PhysicsCategory.coin
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is Barrier ? contact.bodyB.node : contact.bodyA.node
        
        if !(contactNode is CoinNode) { return }
        
        (contactNode as! CoinNode).follow(scene)
    }
}
