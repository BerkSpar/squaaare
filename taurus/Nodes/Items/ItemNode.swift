//
//  ItemNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class ItemNode: SKNode {
    func didContact(_ scene: GameScene) { }
    
    func draw() { }
    
    func configureCollision() {
        physicsBody?.contactTestBitMask = PhysicsCategory.character
        physicsBody?.affectedByGravity = false
    }
    
    func spawn(_ scene: GameScene) {
        let velocity = Double.random(in: 4...8)
        let xPosition = Double.random(in: -scene.frame.width/2 ... scene.frame.width/2)
        let yPosition = (scene.frame.height / 2)
        
        position.y = yPosition
        position.x = xPosition
        
        scene.addChild(self)
        
        run(.move(to: CGPoint(x: position.x, y: -500), duration: velocity))
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
