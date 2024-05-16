//
//  CharacterBulletNode.swift
//  taurus
//
//  Created by Felipe Passos on 07/04/24.
//

import SpriteKit

class CharacterBulletNode: SKNode, Enemy {
    func clone() -> any Item {
        CharacterBulletNode()
    }
    
    var spawnTimeRange: ClosedRange<TimeInterval> = 1...1
    var levelRange: ClosedRange<Int> = 1...1
    var velocity = 0.0
    let id = "character_bullet"
    
    func draw() -> SKNode {
        let node = SKSpriteNode(imageNamed: "shuriken")
        node.size = CGSize(width: 25, height: 25)
        node.position = position
        node.glow()
        
        node.run(.repeatForever(.rotate(byAngle: .pi, duration: 0.1)))
        
        physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        
        addChild(node)
        
        return node.copy() as! SKNode
    }
    
    func configureCollision() {
        physicsBody?.categoryBitMask = PhysicsCategory.character
        
        physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func spawnBullet(_ angle: Double, _ force: Double) {
        run(.repeatForever(.rotate(byAngle: .pi, duration: 1)))
        
        run(.sequence([
            .customAction(withDuration: 1, actionBlock: { node, delta in
                let direction = self.zRotation + angle
                
                let dx = force * cos(direction)
                let dy = force * sin(direction)
                
                self.position.x += dx
                self.position.y += dy
            }),
            .fadeOut(withDuration: 0.3),
            .removeFromParent()
        ]))
    }
    
    func spawn(_ scene: GameScene) {
        
    }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is CharacterBulletNode ? contact.bodyB.node : contact.bodyA.node
                
        if !(contactNode is Item) { return }
        if contactNode is Barrier { return }
        if contactNode is CharacterNode { return }
        if contactNode is CoinNode { return }
        
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
