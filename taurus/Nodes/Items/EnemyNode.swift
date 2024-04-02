//
//  EnemyNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class EnemyNode: SKNode, Item {
    let id = "enemy"
    
    var spawnTimeRange: ClosedRange<TimeInterval>
    var levelRange: ClosedRange<Int>
    var velocityRange: ClosedRange<Double>
    
    var velocity: Double
    
    init(spawnTimeRange: ClosedRange<TimeInterval>, levelRange: ClosedRange<Int>, velocityRange: ClosedRange<Double>) {
        self.spawnTimeRange = spawnTimeRange
        self.levelRange = levelRange
        self.velocityRange = velocityRange
        self.velocity = Double.random(in: velocityRange)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clone() -> any Item {
        EnemyNode(spawnTimeRange: spawnTimeRange, levelRange: levelRange, velocityRange: velocityRange)
    }
    
    func spawn(_ scene: GameScene) {
        let xPosition = Double.random(in: -scene.frame.width/2 ... scene.frame.width/2)
        let yPosition = (scene.frame.height / 2)
        
        position.y = yPosition
        position.x = xPosition
        
        scene.addChild(self)
        
        run(.sequence([
            .move(to: CGPoint(x: position.x, y: -500), duration: velocity),
            .removeFromParent()
        ]))
    }
    
    func draw() {
        let node = SKSpriteNode(imageNamed: "basic_enemy")
        node.size = CGSize(width: 40, height: 40)
        
        physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        
        addChild(node)
    }
    
    func configureCollision() {
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        HapticsService.shared.notify(.error)
        
        RouterService.shared.navigate(.endGame)
    }
}
