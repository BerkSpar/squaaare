//
//  GameScene.swift
//  taurus
//
//  Created by Felipe Passos on 19/03/24.
//

import SpriteKit
import FirebaseAnalytics

class GameScene: SKScene, SKPhysicsContactDelegate {
    let character = CharacterNode()
    let pointsNode = SKLabelNode()
    let spawner = SpawnNode()
    
    override func didMove(to view: SKView) {
        configureScene()
        configureSwipe(view)
        configurePoints()
        configureCharacter()
        
        updatePoints()
        spawner.start(self)
        addChild(spawner)
        
        Analytics.logEvent(AnalyticsEventLevelStart, parameters: [
            AnalyticsParameterLevelName: "game"
        ])
    }
    
    func gameOver() {
        HapticsService.shared.notify(.error)
        
        spawner.stop(self)
        character.die(self) {
            RouterService.shared.navigate(.endGame)
        }
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
    
    func updatePoints() {
        pointsNode.text = GameController.shared.points.formatted()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if (nodeA.name == "bullet" || nodeB.name == "bullet") {
            gameOver()
            return
        }
        
        if (nodeA is Item) { (nodeA as! Item).didContact(self, contact) }
        if (nodeB is Item) { (nodeB as! Item).didContact(self, contact) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        character.move()
    }
}
