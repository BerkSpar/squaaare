//
//  AbilityModal.swift
//  taurus
//
//  Created by Felipe Passos on 04/04/24.
//

import SpriteKit
import GoogleMobileAds
import FirebaseAnalytics

class AbilityModal: SKNode, GADFullScreenContentDelegate {
    var canReroll = false
    
    var abilities: [AbilityNode] = []
    var gameScene: GameScene?
    
    func populate(_ scene: GameScene, callback: @escaping () -> Void) {
        abilities = [
            AbilityNode(imageNamed: "strong_power_up") {
                Analytics.logEvent("select_content", parameters: [
                    AnalyticsParameterLevel: GameController.shared.points,
                    AnalyticsParameterLevelName: "game",
                    AnalyticsParameterContentType: "ability",
                    AnalyticsParameterContent: "strong_power_up"
                ])
                
                scene.character.addBarrier()
                self.hide(callback: callback)
            },
            AbilityNode(imageNamed: "life_power_up") {
                Analytics.logEvent("select_content", parameters: [
                    AnalyticsParameterLevel: GameController.shared.points,
                    AnalyticsParameterLevelName: "game",
                    AnalyticsParameterContentType: "ability",
                    AnalyticsParameterContent: "life_power_up"
                ])
                
                self.hide(callback: callback)
            },
            AbilityNode(imageNamed: "accelerate_power_up") {
                Analytics.logEvent("select_content", parameters: [
                    AnalyticsParameterLevel: GameController.shared.points,
                    AnalyticsParameterLevelName: "game",
                    AnalyticsParameterContentType: "ability",
                    AnalyticsParameterContent: "accelerate_power_up"
                ])
                
                scene.character.playerSpeed += scene.character.playerSpeed * 0.2
                self.hide(callback: callback)
            },
            AbilityNode(imageNamed: "captalist_power_up") {
                Analytics.logEvent("select_content", parameters: [
                    AnalyticsParameterLevel: GameController.shared.points,
                    AnalyticsParameterLevelName: "game",
                    AnalyticsParameterContentType: "ability",
                    AnalyticsParameterContent: "captalist_power_up"
                ])
                
                scene.character.addCaptalist()
                self.hide(callback: callback)
            }
        ]
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        if canReroll { 
            reroll()
            childNode(withName: "reroll_button")?.removeFromParent()
        }
        
        gameScene?.pause()
    }
    
    func adWillDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        gameScene?.pause()
    }
    
    func adWillPresentFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        gameScene?.pause()
    }
    
    private func reroll() {
        for child in children {
            if child.name == "ability" {
                child.run(.sequence([
                    .scale(to: 0, duration: 0.5),
                    .removeFromParent()
                ]))
            }
        }
        
        run(.sequence([
            .wait(forDuration: 0.5),
            .run {
                self.drawAbilities()
            }
        ]))
        
        Analytics.logEvent("reroll", parameters: [
            AnalyticsParameterLevel: GameController.shared.points,
            AnalyticsParameterLevelName: "game"
        ])
    }
    
    private func showRewaredAd() {
        if let ad = RewardedAd.shared.rewardedAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: nil) {
                self.canReroll = true
            }
        }
    }
    
    private func drawAbilities() {
        let ability1 = abilities.remove(at: Int.random(in: 0...abilities.count-1))
        ability1.name = "ability"
        ability1.position.y -= 150
        ability1.position.x -= 100
        ability1.setScale(0)
        addChild(ability1)

        let ability2 = abilities.remove(at: Int.random(in: 0...abilities.count-1))
        ability2.name = "ability"
        ability2.position.y -= 150
        ability2.position.x += 100
        ability2.setScale(0)
        addChild(ability2)
        
        ability1.run(.sequence([
            .scale(to: 1, duration: 0.5)
        ]))
        ability2.run(.sequence([
            .scale(to: 1, duration: 0.5)
        ]))
    }
    
    func hide(callback: @escaping () -> Void) {
        for child in children {
            if child.name == "background" { continue }
            
            child.run(.sequence([
                .scale(to: 0, duration: 0.5),
                .removeFromParent()
            ]))
        }
        
        run(.sequence([
            .wait(forDuration: 0.5),
            .run {
                self.removeAllActions()
                self.removeAllChildren()
                callback()
            }
        ]))
    }
    
    func show(_ scene: GameScene, callback: @escaping () -> Void) {
        gameScene = scene
        populate(scene, callback: callback)
        zPosition = 1000
        
        let background = SKShapeNode(rectOf: scene.frame.size)
        background.name = "background"
        background.fillColor = .background.withAlphaComponent(0.8)
        addChild(background)
        
        let title = SKLabelNode(text: "NEW ABILITY")
        title.fontName = "Modak"
        title.fontSize = 48
        title.fontColor = .white
        title.addStroke(color: .primary, width: 5)
        addChild(title)
        
        let rerollButton = ButtonNode(imageNamed: "reroll_button") {
            self.showRewaredAd()
        }
        rerollButton.name = "reroll_button"
        rerollButton.position.y -= 300
        addChild(rerollButton)
        rerollButton.run(.repeat(.sequence([
            .wait(forDuration: 2),
            .rotate(byAngle: 0.5, duration: 0.1),
            .rotate(byAngle: -1, duration: 0.1),
            .rotate(byAngle: 0.5, duration: 0.1)
        ]), count: 3))
        
        drawAbilities()
    }
}
