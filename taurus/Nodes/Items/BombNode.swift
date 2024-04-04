//
//  BombNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class BombNode: SKNode, Item {
    let id = "bomb"
    
    var spawnTimeRange: ClosedRange<TimeInterval>
    var levelRange: ClosedRange<Int>
    var velocityRange: ClosedRange<Double>
    
    var velocity: Double
    
    var label: SKLabelNode = SKLabelNode(text: "3")
    var time = 3
    
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
        BombNode(spawnTimeRange: spawnTimeRange, levelRange: levelRange, velocityRange: velocityRange)
    }
    
    func spawnBullet(_ scene: GameScene, _ angle: Double, _ force: Double) {
        let node = SKShapeNode(ellipseOf: CGSize(width: 15, height: 15))
        node.strokeColor = .grape
        node.fillColor = .grape
        node.position = position
        
        node.name = "bullet"
        node.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        node.physicsBody?.contactTestBitMask = PhysicsCategory.character
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.collisionBitMask = 0;
        
        self.scene?.addChild(node)
        
        let dx = force * cos(angle)
        let dy = force * sin(angle)
        
        node.run(.sequence([
            .move(by: CGVector(dx: dx, dy: dy), duration: 1),
            .fadeOut(withDuration: 0.3),
            .removeFromParent()
        ]))
    }
    
    func spawn(_ scene: GameScene) {
        let xPosition = Double.random(in: -scene.frame.width/2+50 ... scene.frame.width/2-50)
        let yPosition = (scene.frame.height / 2)
        
        position.y = yPosition
        position.x = xPosition
        
        scene.addChild(self)
        
        run(.sequence([
            .move(to: CGPoint(x: position.x, y:  Double.random(in: -400...400)), duration: 2),
            .repeat(.sequence([
                .run {
                    self.time -= 1
                    self.label.text = self.time.formatted()
                },
                .scale(to: 0.8, duration: 0.3),
                .scale(to: 1.2, duration: 0.3),
                .scale(to: 1, duration: 0.3),
            ]), count: 3),
            .run {
                let angles = [0, 1, 2, 3, 4, 5].map { $0 * Double.pi/3 }
                for angle in angles {
                    self.spawnBullet(scene, angle, 100)
                }
            },
            .run {
                scene.bombShake()
            },
            .removeFromParent(),
            .run {
                for _ in 1...3 {
                    let coin = CoinNode(spawnTimeRange: 0...0, levelRange: 0...0, pointsRange: 1...5, velocityRange: 0...0)
                    coin.draw()
                    coin.configureCollision()
                    coin.position = self.position
                    
                    coin.position.x += Double.random(in: -30...30)
                    coin.position.y += Double.random(in: -30...30)
                    
                    scene.addChild(coin)
                    
                    coin.run(.sequence([
                        .wait(forDuration: 5.5),
                        .fadeOut(withDuration: 0.5),
                        .removeFromParent()
                    ]))
                }
            }
        ]))
    }
    
    func draw() {
        let node = SKSpriteNode(imageNamed: "bomb_enemy")
        node.size = CGSize(width: 70, height: 70)
        
        physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        
        addChild(node)
        
        label.fontColor = .primary
        label.fontName = "Modak"
        label.fontColor = .grape
        label.fontSize = 24
        label.position.y -= 7
        
        node.addChild(label)
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
