//
//  GameScene.swift
//  taurus
//
//  Created by Felipe Passos on 19/03/24.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let character = CharacterNode()
    let pointsNode = SKLabelNode(text: GameController.shared.points.formatted())
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(pointsNode)
        addChild(character)
        
        startSpawner()
    }
    
    func startSpawner() {
        run(.repeatForever(.sequence([
            .wait(forDuration: Double.random(in: 1...5)),
            .run {
                let enemy = EnemyNode()
                enemy.spawn(self)
            }
        ])))
        
        run(.repeatForever(.sequence([
            .wait(forDuration: Double.random(in: 2...3)),
            .run {
                let coin = CoinNode()
                coin.spawn(self)
            }
        ])))
    }
    
    func updatePoints() {
        pointsNode.text = GameController.shared.points.formatted()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if (nodeA is ItemNode) { (nodeA as! ItemNode).didContact(self, contact) }
        if (nodeB is ItemNode) { (nodeB as! ItemNode).didContact(self, contact) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        character.move()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPosition = touch.location(in: self)
        
        HapticsService.shared.play(.medium)
        
        if touchPosition.x < 0 {
            character.rotate()
        } else {
            character.rotate(true)
        }
    
        updatePoints()
    }
}
