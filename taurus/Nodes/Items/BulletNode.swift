//
//  BulletNode.swift
//  taurus
//
//  Created by Felipe Passos on 07/04/24.
//

import SpriteKit

class BulletNode: SKNode, Enemy {
    func clone() -> any Item {
        BulletNode()
    }
    
    var spawnTimeRange: ClosedRange<TimeInterval> = 1...1
    var levelRange: ClosedRange<Int> = 1...1
    var velocity = 0.0
    let id = "bullet"
    
    func draw() -> SKNode {
        let node = SKShapeNode(ellipseOf: CGSize(width: 15, height: 15))
        node.strokeColor = .grape
        node.fillColor = .grape
        node.position = position
        
        addChild(node)
        
        return node.copy() as! SKNode
    }
    
    func configureCollision() {
        physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func spawnBullet(_ scene: GameScene, _ angle: Double, _ force: Double) {
        let dx = force * cos(angle)
        let dy = force * sin(angle)
        
        run(.sequence([
            .move(by: CGVector(dx: dx, dy: dy), duration: 1),
            .fadeOut(withDuration: 0.3),
            .removeFromParent()
        ]))
    }
    
    func spawn(_ scene: GameScene) {
        
    }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is BulletNode ? contact.bodyB.node : contact.bodyA.node
                
        if contactNode is Barrier { return }
        if contactNode is Enemy { return }
        
        removeFromParent()
        scene.gameOver()
    }
    
    
}
