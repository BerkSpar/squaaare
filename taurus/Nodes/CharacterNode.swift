//
//  CharacterNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

enum RotateType {
    case up
    case down
    case left
    case right
}

class CharacterNode: SKNode {
    var isRotating = false
    var playerSpeed: CGFloat = 2.0
    
    override init() {
        super.init()
        
        self.draw()
    }
    
    func addShuriken(angle: Double) {
        run(.repeat(.sequence([
            .run {
                let bullet = CharacterBulletNode()
                _ = bullet.draw()
                bullet.configureCollision()
                bullet.position = self.position
                bullet.zRotation = self.zRotation
                self.scene?.addChild(bullet)
                
                bullet.spawnBullet(angle, 5)
            },
            .wait(forDuration: 1)
        ]), count: 15))
    }
    
    func die(_ scene: GameScene, callback: @escaping () -> Void) {
        playerSpeed = 0
        
        run(.sequence([
            .hide(),
            .repeat(.sequence([
                .run {
                    let node = SKSpriteNode(imageNamed: "character")
                    node.size = CGSize(width: 40, height: 40)
                    node.position = self.position
                    scene.addChild(node)
                    
                    node.run(.sequence([
                        .group([
                            .scale(to: 0, duration: 1),
                            .move(by: CGVector(dx: Int.random(in: -75...75), dy: Int.random(in: -75...75)), duration: 1),
                            .fadeOut(withDuration: 1),
                        ]),
                        .run {
                            callback()
                        }
                    ]))
                }
            ]), count: 15)
        ]))
    }
    
    func addBarrier() {
        let barrier = Barrier()
        barrier.alpha = 0
        addChild(barrier)
        
        barrier.run(.fadeIn(withDuration: 0.3))
    }
    
    func addCaptalist() {
        for child in children {
            if child is Captalist {
                child.removeFromParent()
            }
        }
        
        let captalist = Captalist()
        captalist.alpha = 0
        addChild(captalist)
        
        captalist.run(.sequence([
            .fadeIn(withDuration: 0.3),
            .wait(forDuration: 20),
            .removeFromParent()
        ]))
    }
    
    func draw() {
        let node = SKSpriteNode(imageNamed: "character")
        node.size = CGSize(width: 40, height: 40)
        node.zPosition = 10
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
       
        node.physicsBody?.categoryBitMask = PhysicsCategory.character
        node.physicsBody?.contactTestBitMask = PhysicsCategory.coin | PhysicsCategory.enemy
        node.physicsBody?.collisionBitMask = 0;
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        
        addChild(node)
        
        let pointer = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        pointer.position = self.position
        pointer.position.y += 50
        pointer.strokeColor = .red
        pointer.fillColor = .red
        addChild(pointer)
    }
    
    func move() {
        let direction = zRotation + CGFloat.pi / 2
        
        let dx = playerSpeed * cos(direction)
        let dy = playerSpeed * sin(direction)
        
        position.x += dx
        position.y += dy
        
        if position.x > scene!.frame.width / 2 {
            position.x = -scene!.frame.width / 2
        }
        
        if position.x < -scene!.frame.width / 2 {
            position.x = scene!.frame.width / 2
        }
        
        if position.y > scene!.frame.height / 2 {
            position.y = -scene!.frame.height / 2
        }
        
        if position.y < -scene!.frame.height / 2 {
            position.y = scene!.frame.height / 2
        }
    }
    
    var lastRotation: RotateType = .up
    func rotate(_ type: RotateType) {
        if type == lastRotation { return }
        if isRotating { return }
        
        isRotating = true
        lastRotation = type
        var angle = 0.0
        
        switch type {
        case .up:
            angle = 0
        case .down:
            angle = .pi
        case .left:
            angle = .pi/2
        case .right:
            angle = -.pi/2
        }
                
        if ConfigService.shared.rotateCharacter {
            run(.rotate(toAngle: angle, duration: 0.2, shortestUnitArc: true)) {
                self.isRotating = false
            }
        } else {
            self.zRotation = angle
            self.isRotating = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
