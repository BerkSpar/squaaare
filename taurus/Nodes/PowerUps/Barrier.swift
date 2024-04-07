//
//  Barrier.swift
//  taurus
//
//  Created by Felipe Passos on 07/04/24.
//

import SpriteKit

class Barrier: SKNode, Contactable {
    override init() {
        super.init()
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() {
        let circle = SKShapeNode(circleOfRadius: 40)
        circle.name = "barrier"
        circle.strokeColor = .accentBlue
        circle.lineWidth = 5
        
        physicsBody = SKPhysicsBody(circleOfRadius: 40)
        physicsBody?.categoryBitMask = PhysicsCategory.character
        
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
        
        addChild(circle)
    }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is Barrier ? contact.bodyB.node : contact.bodyA.node
        
        if contactNode is CoinNode { return }
        if !(contactNode is Item) { return }
        
        HapticsService.shared.play(.rigid)
        
        contactNode?.removeAllActions()
        contactNode?.physicsBody?.contactTestBitMask = 0
        contactNode?.physicsBody?.collisionBitMask = 0
        contactNode?.physicsBody?.categoryBitMask = 0
        
        contactNode?.run(.sequence([
            .hide(),
            .repeat(.sequence([
                .run {
                    let clone = (contactNode as! Item).clone()
                    let node = clone.draw()
                    
                    node.position = contactNode!.position
                    scene.addChild(node)
                    
                    node.run(.sequence([
                        .group([
                            .scale(to: 0, duration: 1),
                            .move(by: CGVector(dx: Int.random(in: -75...75), dy: Int.random(in: -75...75)), duration: 1),
                            .fadeOut(withDuration: 1),
                        ])
                    ]))
                }
            ]), count: 5)
        ]))
        
        run(.sequence([
            .fadeOut(withDuration: 0.3),
            .removeFromParent()
        ]))
    }
}
