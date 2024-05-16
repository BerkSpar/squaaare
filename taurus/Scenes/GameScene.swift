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
    var pointsNode = SKLabelNode()
    let spawner = SpawnNode()
    let abilityModal = AbilityModal()
    let coins = SKSpriteNode(imageNamed: "yellow_coin")
    
    var isShowingModal = false
    
    override func didMove(to view: SKView) {
        configureScene()
        configureSwipe(view)
        configurePoints()
        configureCharacter()
        
        updatePoints()
        spawner.start(self)
        addChild(spawner)
        
        abilityModal.name = "modal"
        addChild(abilityModal)
        
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
        backgroundColor = .black
        
        let background = SKSpriteNode(imageNamed: "grid_background")
        background.size = frame.size
        background.zPosition = -1
        addChild(background)
    }
    
    func configureCharacter() {
        addChild(character)
    }
    
    func configurePoints() {
        coins.size = CGSize(width: 20, height: 20)
        coins.position = CGPoint(x: -frame.width / 2, y: frame.height / 2)
        coins.position.x += 40
        coins.position.y -= 80
        addChild(coins)
        
        pointsNode = SKLabelNode(
            attributedText: NSAttributedString(
              string: "0",
              attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .black),
                .foregroundColor : UIColor.neonYellow,
                .strokeWidth : -5,
              ]
            )
          )
        pointsNode.position = coins.position
        pointsNode.position.x += 30
        pointsNode.position.y -= 12
        
        addChild(pointsNode)
        
        coins.zPosition = 1000
        pointsNode.zPosition = 1000
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
        pointsNode.updateAttributedText(GameController.shared.points.formatted())
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if (nodeA is Contactable) { (nodeA as! Contactable).didContact(self, contact) }
        if (nodeB is Contactable) { (nodeB as! Contactable).didContact(self, contact) }
    }
    
    func pause() {
        for child in children {
            if child.name == "modal" { continue }
            child.isPaused = true
        }
    }
    
    func unpause() {
        for child in children {
            child.isPaused = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isShowingModal { return }
        
        if GameController.shared.canGoNextLevel() {
            self.pause()
            self.isShowingModal = true
            
            abilityModal.show(self) {
                self.unpause()
                self.isShowingModal = false
            }
        }
        
        character.move()
    }
}
