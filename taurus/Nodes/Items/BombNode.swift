//
//  BombNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class BombNode: SKNode, Enemy {
    let id = "bomb"
    
    var spawnTimeRange: ClosedRange<TimeInterval>
    var levelRange: ClosedRange<Int>
    var velocityRange: ClosedRange<Double>
    
    var velocity: Double
    
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
                },
                .scale(to: 0.8, duration: 0.3),
                .scale(to: 1.2, duration: 0.3),
                .scale(to: 1, duration: 0.3),
            ]), count: 3),
            .run {
                let angles = [0, 1, 2, 3, 4, 5].map { $0 * Double.pi/3 }
                for angle in angles {
                    let bullet = BulletNode()
                    bullet.draw()
                    bullet.configureCollision()
                    bullet.position = self.position
                    scene.addChild(bullet)
                    
                    bullet.spawnBullet(scene, angle, 100)
                }
            },
            .run {
                scene.bombShake()
                HapticsService.shared.play(.heavy)
            },
            .removeFromParent(),
            .run {
                for _ in 1...3 {
                    let coin = CoinNode(spawnTimeRange: 0...0, levelRange: 0...0, pointsRange: 1...1, velocityRange: 0...0)
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
    
    func draw() -> SKNode {
        let node = SKSpriteNode(imageNamed: "bomb_enemy")
        node.size = CGSize(width: 70, height: 70)
        node.glow()
        
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
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) {
        let contactNode = contact.bodyA.node is BombNode ? contact.bodyB.node : contact.bodyA.node
                
        if contactNode is Barrier { return }
        if contactNode is Enemy { return }
        if contactNode is CharacterBulletNode { return }
        
        removeFromParent()
        scene.gameOver()
    }
}
