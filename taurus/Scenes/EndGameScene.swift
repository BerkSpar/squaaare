//
//  EndGameScene.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit
import SwiftUI
import GoogleMobileAds
import FirebaseAnalytics

class EndGameScene: SKScene, GADFullScreenContentDelegate {
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .background
        
        draw()
        
        Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [
            AnalyticsParameterLevel: GameController.shared.points,
            AnalyticsParameterLevelName: "game"
        ])
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        RouterService.shared.navigate(.game)
    }
    
    func oneMoreChange() {
        HapticsService.shared.play(.heavy)
        
        if let ad = RewardedAd.shared.rewardedAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: self.view?.window?.rootViewController) {
                GameController.shared.oneMoreChance = false
            }
            
        }
    }
    
    func tryAgain() {
        HapticsService.shared.play(.heavy)
        GameController.shared.save()
        
        RouterService.shared.navigate(.game)
    }
    
    func goToMenu() {
        HapticsService.shared.play(.heavy)
        GameController.shared.save()
        RouterService.shared.navigate(.start)
    }
    
    func draw() {
        let tryAgain = ButtonNode(imageNamed: "try_again") {
            self.tryAgain()
        }
        tryAgain.size = CGSize(width: 260, height: 60)
        addChild(tryAgain)
        
        let menu = ButtonNode(imageNamed: "menu_button") {
            self.goToMenu()
        }
        menu.size = CGSize(width: 260, height: 60)
        menu.position.y = tryAgain.position.y - 80
        addChild(menu)
        
        var titlePosition = tryAgain.position.y + 80
        
        if (GameController.shared.oneMoreChance) {
            let adButton = ButtonNode(imageNamed: "one_more_chance") {
                self.oneMoreChange()
            }
            adButton.position.y = tryAgain.position.y + 80
            adButton.size = CGSize(width: 260, height: 60)
            addChild(adButton)
            
            let ad = SKSpriteNode(imageNamed: "ad_button")
            ad.size = CGSize(width: 50, height: 50)
            ad.position = CGPoint(
                x: adButton.size.width / 2,
                y: adButton.size.height / 2
            )
            adButton.addChild(ad)
            
            titlePosition = adButton.position.y + 80
        }
        
        let title = SKLabelNode(text: "\(GameController.shared.points.formatted()) pts")
        title.position.y = titlePosition
        title.fontColor = .primary
        title.fontName = "Modak"
        title.fontSize = 48
        
        addChild(title)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        let version = SKLabelNode(text: "v\(appVersion)+\(buildNumber)")
        version.position.y = -frame.height / 2 + 50
        version.fontColor = .secondary
        version.fontName = "Modak"
        version.fontSize = 14
        
        addChild(version)
    }
}
