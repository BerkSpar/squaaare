//
//  CharacterNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class CharacterNode: SKNode {
    var isRotating = false
    
    override init() {
        super.init()
        
        self.draw()
    }
    
    func draw() {
        let node = SKShapeNode(rectOf: CGSize(width: 40, height: 40), cornerRadius: 8)
        node.fillColor = .blue
        node.strokeColor = .blue
        node.zPosition = 10
        
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
       
        node.physicsBody?.categoryBitMask = PhysicsCategory.character
        node.physicsBody?.contactTestBitMask = PhysicsCategory.coin | PhysicsCategory.enemy
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        
        addChild(node)
    }
    
    func move() {
        let playerSpeed: CGFloat = 2.0
        let direction = zRotation + CGFloat.pi / 2
        
        let dx = playerSpeed * cos(direction)
        let dy = playerSpeed * sin(direction)
        
        position.x += dx
        position.y += dy
    }
    
    func rotate(_ left: Bool = false) {
        if isRotating { return }
        
        isRotating = true
        var angle = 0.0
        if left {
            angle = zRotation - .pi/2
        } else {
            angle = zRotation + .pi/2
        }

        run(.rotate(toAngle: angle, duration: 0.2)) {
            self.isRotating = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
