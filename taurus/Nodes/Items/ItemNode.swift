//
//  ItemNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class ItemNode: SKNode {
    func getVelocity() -> Double { Double.random(in: 4...8) }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact) { }
    
    func draw() { }
    
    func configureCollision() {
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0;
    }
    
    func spawn(_ scene: GameScene) {
        let xPosition = Double.random(in: -scene.frame.width/2 ... scene.frame.width/2)
        let yPosition = (scene.frame.height / 2)
        
        position.y = yPosition
        position.x = xPosition
        
        scene.addChild(self)
        
        run(.sequence([
            .move(to: CGPoint(x: position.x, y: -500), duration: getVelocity()),
            .removeFromParent()
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        draw()
        configureCollision()
    }
    
    override init() {
        super.init()
        
        draw()
        configureCollision()
    }
}
