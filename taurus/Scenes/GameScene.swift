//
//  GameScene.swift
//  taurus
//
//  Created by Felipe Passos on 19/03/24.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let character = CharacterNode()
    let pointsNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        configureScene()
        configureSwipe(view)
        configurePoints()
        configureCharacter()
        
        updatePoints()
        startSpawner()
    }
    
    func configureScene() {
        physicsWorld.contactDelegate = self
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .background
    }
    
    func configureCharacter() {
        addChild(character)
    }
    
    func configurePoints() {
        pointsNode.fontSize = 64
        pointsNode.fontColor = .secondary
        pointsNode.fontName = "Modak"
        
        addChild(pointsNode)
    }
    
    func configureSwipe(_ view: SKView) {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        character.rotate(.right)
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        character.rotate(.left)
    }
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        character.rotate(.up)
    }
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        character.rotate(.down)
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
            .wait(forDuration: Double.random(in: 2...4)),
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let touchPosition = touch.location(in: self)
//        
//        HapticsService.shared.play(.medium)
//        
//        if touchPosition.x < 0 {
//            character.rotate()
//        } else {
//            character.rotate(true)
//        }
//    
//        updatePoints()
//    }
}
