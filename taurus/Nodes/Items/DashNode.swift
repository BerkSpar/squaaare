//
//  DashNode.swift
//  taurus
//
//  Created by Gabriel Bruno Meira on 26/03/24.
//

import Foundation
import SpriteKit

class DashNode: SKNode, Item {
    let id = "dash"
    
    var spawnTimeRange: ClosedRange<TimeInterval>
    var levelRange: ClosedRange<Int>
    var velocity: Double
    var voltar: Bool
    
    init(spawnTimeRange: ClosedRange<TimeInterval>, levelRange: ClosedRange<Int>, voltar: Bool) {
        self.spawnTimeRange = spawnTimeRange
        self.levelRange = levelRange
        self.velocity = 0
        self.voltar = voltar
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is DashNode ? contact.bodyB.node : contact.bodyA.node
                
        if contactNode is Barrier { return }
        
        removeFromParent()
        scene.gameOver()
    }
    
    func draw() -> SKNode {
        let node = SKSpriteNode(imageNamed: "dash_enemy")
        node.size = CGSize(width: 40, height: 40)
        
        physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        
        addChild(node)
        
        return node.copy() as! SKNode
    }
    
    func configureCollision() {
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func spawn(_ scene: GameScene) {
        let xPosition = Double.random(in: -scene.frame.width/2+70 ... scene.frame.width/2-70)
        let yPosition = (scene.frame.height / 2)
        
        position.y = yPosition
        position.x = xPosition
        
        scene.addChild(self)
        
        let isLeft = Bool.random()
        let multiplicador = isLeft ? 1.0 : -1.0
        let voltarPosicao = voltar ? 1000.0 : -1000.0
        
        let rotationAngle: CGFloat = multiplicador > 0 ? .pi / 2 : -.pi / 2
        
        run(.sequence([
            .move(by: CGVector(dx: 0, dy: -70), duration: Double.random(in: 0.5...1)),
            
            .rotate(toAngle: rotationAngle, duration: 0.5, shortestUnitArc: true),
            .move(by: CGVector(dx: Double.random(in: 20...30) * multiplicador, dy: 0), duration: Double.random(in: 0.5...1)),
            
            .rotate(toAngle: 0, duration: 0.5, shortestUnitArc: true),
            .move(by: CGVector(dx: 0, dy: -70), duration: Double.random(in: 0.5...1)),
            
            .rotate(toAngle: rotationAngle, duration: 0.5, shortestUnitArc: true),
            .move(by: CGVector(dx: Double.random(in: 20...30) * multiplicador, dy: 0), duration: Double.random(in: 0.5...1)),
            
            .rotate(toAngle: 0, duration: 0.5, shortestUnitArc: true),
            .move(by: CGVector(dx: 0, dy: -70), duration: Double.random(in: 0.5...1)),
            
            .rotate(toAngle: rotationAngle, duration: 0.5, shortestUnitArc: true),
            .move(by: CGVector(dx: Double.random(in: 20...30) * multiplicador, dy: 0), duration: Double.random(in: 0.5...1)),
            
            .rotate(toAngle: 0, duration: 0.5, shortestUnitArc: true),
            .scaleY(to: 0.8, duration: 0.3),
            .scaleY(to: 1.2, duration: 0.3),
            .scaleY(to: 1, duration: 0.3),
            .move(by: CGVector(dx: 0, dy: -800), duration: Double.random(in: 0.5...1)),
            .rotate(byAngle: Double.pi, duration: 0),
            .moveTo(y: voltarPosicao, duration: Double.random(in: 0.5...1))
        ]))
        
    }
    
    func clone() -> Item {
        DashNode(spawnTimeRange: spawnTimeRange, levelRange: levelRange, voltar: voltar)
    }
}
