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
import StoreKit

class EndGameScene: SKScene, GADFullScreenContentDelegate {
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black
        
        draw()
        
        GameController.shared.submitScore()

        if (ConfigService.shared.showPosGameInterstitial && PlayerDataManager.shared.playerData.showAds) {
            showAd()
        }
        
        Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [
            AnalyticsParameterLevel: GameController.shared.points,
            AnalyticsParameterLevelName: "game"
        ])
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        if ad is GADRewardedAd {
            RouterService.shared.navigate(.game)
        }
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
    
    func showAd() {
        if let ad = InterstitialAd.shared.interstitialAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: self.view?.window?.rootViewController)
            InterstitialAd.shared.loadAd(withAdUnitId: AdService.posGameIntersticalId)
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
        let background = SKSpriteNode(imageNamed: "grid_background")
        background.size = frame.size
        background.zPosition = -1
        addChild(background)
        
        let tryAgain = SquareButtonNode(name: "play_larger") {
            self.tryAgain()
        }
        tryAgain.size = CGSize(width: 235, height: 56)
        tryAgain.glow()
        addChild(tryAgain)
        
        let menu = SquareButtonNode(name: "menu_larger") {
            self.goToMenu()
        }
        menu.size = CGSize(width: 235, height: 56)
        menu.position.y = tryAgain.position.y - 100
        menu.glow()
        addChild(menu)
        
        let store = SquareButtonNode(name: "shop_larger") {
            RouterService.shared.navigate(.store)
        }
        store.size = CGSize(width: 235, height: 56)
        store.position.y = menu.position.y - 100
        store.glow()
        addChild(store)
        
        var titlePosition = tryAgain.position.y + 80
        
        if (GameController.shared.oneMoreChance && RewardedAd.shared.rewardedAd != nil && PlayerDataManager.shared.playerData.showAds) {
            let adButton = SquareButtonNode(name: "continue_larger") {
                self.oneMoreChange()
            }
            adButton.position.y = tryAgain.position.y + 100
            adButton.size = CGSize(width: 235, height: 56)
            adButton.glow()
            addChild(adButton)
            
            let ad = SKSpriteNode(imageNamed: "ad_tooltip")
            ad.size = CGSize(width: 30, height: 30)
            ad.position = CGPoint(
                x: adButton.size.width / 2,
                y: adButton.size.height / 2
            )
            adButton.addChild(ad)
            
            adButton.run(.repeat(.sequence([
                .wait(forDuration: 1),
                .rotate(byAngle: 0.3, duration: 0.1),
                .rotate(byAngle: -0.6, duration: 0.1),
                .rotate(byAngle: 0.3, duration: 0.1)
            ]), count: 3))
            
            titlePosition = adButton.position.y + 80
        }
        
        if (GameController.shared.oneMoreChance && !PlayerDataManager.shared.playerData.showAds) {
            let adButton = SquareButtonNode(name: "continue_larger") {
                RouterService.shared.navigate(.game)
            }
            adButton.position.y = tryAgain.position.y + 100
            adButton.size = CGSize(width: 235, height: 56)
            adButton.glow()
            addChild(adButton)
            
            titlePosition = adButton.position.y + 80
        }
        
        let title = SKLabelNode(
            attributedText: NSAttributedString(
              string: "\(GameController.shared.points.formatted()) pts",
              attributes: [
                .font: UIFont.systemFont(ofSize: 48, weight: .black),
                .foregroundColor : UIColor.neonBlue,
                .strokeWidth : -5
              ]
            )
          )
        title.position.y = titlePosition
        title.glow(yPosition: 16)
        
        addChild(title)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        let version = SKLabelNode(
            attributedText: NSAttributedString(
              string: "v\(appVersion)+\(buildNumber)",
              attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .black),
                .foregroundColor : UIColor.neonBlue,
                .strokeWidth : -5,
              ]
            )
          )
        version.position.y = -frame.height / 2 + 30
        
        addChild(version)
    }
}
