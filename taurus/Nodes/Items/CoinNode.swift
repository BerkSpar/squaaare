//
//  CoinNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class CoinNode: SKNode, Item {
    let id = "coin"
    
    let spawnTimeRange: ClosedRange<TimeInterval>
    let levelRange: ClosedRange<Int>
    let pointsRange: ClosedRange<Int>
    let velocityRange: ClosedRange<Double>
    
    let velocity: Double
    let points: Int
    
    init(spawnTimeRange: ClosedRange<TimeInterval>, levelRange: ClosedRange<Int>, pointsRange: ClosedRange<Int>, velocityRange: ClosedRange<Double>) {
        self.spawnTimeRange = spawnTimeRange
        self.levelRange = levelRange
        self.pointsRange = pointsRange
        self.velocityRange = velocityRange
        
        self.velocity = Double.random(in: velocityRange)
        self.points = Int.random(in: pointsRange)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clone() -> any Item {
        CoinNode(spawnTimeRange: spawnTimeRange, levelRange: levelRange, pointsRange: pointsRange, velocityRange: velocityRange)
    }
    
    func draw() -> SKNode {
        let node = SKSpriteNode(imageNamed: "coin")
        node.size = CGSize(width: 30, height: 30)
        
        physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        
        addChild(node)
        
        let label = SKLabelNode(text: points.formatted())
        label.fontColor = .primary
        label.fontName = "Modak"
        label.fontColor = .mostard
        label.fontSize = 18
        label.position.y -= 7
        
        node.addChild(label)
        
        return node.copy() as! SKNode
    }
    
    func configureCollision() {
        physicsBody?.categoryBitMask = PhysicsCategory.coin
        
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is CoinNode ? contact.bodyB.node : contact.bodyA.node
                
        if contactNode is Barrier { return }
        
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
}
