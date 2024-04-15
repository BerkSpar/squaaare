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
    let abilityModal = AbilityModal()
    
    var isShowingModal = false
    
    override func didMove(to view: SKView) {
        configureScene()
//        configureSwipe(view)
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
    
    var lastTouch: CGPoint?
    var lastUpdateTime: TimeInterval = 0
    let touchUpdateInterval: TimeInterval = 0.1 // Defina o intervalo de tempo que funciona bem para você

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let currentTime = touch.timestamp
        let timeSinceLastUpdate = currentTime - lastUpdateTime
        
        // Verifica se passou tempo suficiente desde a última atualização
        if timeSinceLastUpdate > touchUpdateInterval {
            if lastTouch == nil || distanceBetweenPoints(lastTouch!, location) > 10 { // Ajuste a margem aqui
                lastTouch = location
                lastUpdateTime = currentTime
            }
        }

        if lastTouch == nil { lastTouch = location }

        let node = SKShapeNode(ellipseOf: CGSize(width: 10, height: 10))
        node.fillColor = .red
        node.strokeColor = .red
        node.position = location

        addChild(node)

        node.run(.sequence([
            .fadeOut(withDuration: 1),
            .removeFromParent()
        ]))

        let swipeVector = CGVector(dx: location.x - lastTouch!.x, dy: location.y - lastTouch!.y)
        let magnitude = sqrt(swipeVector.dx * swipeVector.dx + swipeVector.dy * swipeVector.dy)

        if magnitude > 0 {
            let normalizedSwipeVector = CGVector(dx: swipeVector.dx / magnitude, dy: swipeVector.dy / magnitude)
            let angle = atan2(normalizedSwipeVector.dy, normalizedSwipeVector.dx)
            character.run(.rotate(toAngle: angle, duration: 0.05, shortestUnitArc: true))
        }

        lastTouch = location
    }

    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }


}
