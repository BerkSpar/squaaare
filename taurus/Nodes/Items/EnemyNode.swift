//
//  EnemyNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

class EnemyNode: ItemNode {
    private let sheet = SpriteSheet(
        texture: SKTexture(imageNamed: "SmallSlime_Green"),
        rows: 6,
        columns: 4
    )
    
    override func getVelocity() -> Double {
        Double.random(in: 8...12)
    }
    
    override func draw() {
        let texture = sheet.textureForColumn(column: 0, row: 3)!
        let node = SKSpriteNode(texture: texture)
        node.size = CGSize(width: 60, height: 60)
        
        let spriteSheet = Array(0...3).map { sheet.textureForColumn(column: $0, row: 3)! }
        
        node.run(.repeatForever(.animate(with: spriteSheet, timePerFrame: 0.1)))
        
        addChild(node)
    }
    
    override func configureCollision() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 40))
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        super.configureCollision()
    }
    
    override func didContact(_ scene: SKScene, _ contact: SKPhysicsContact) {
        HapticsService.shared.notify(.error)
        RouterService.shared.navigate(.endGame)
    }
}
