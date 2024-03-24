//
//  EndGameScene.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit
import SwiftUI
import GoogleMobileAds

class EndGameScene: SKScene {
    var adSettings: AdSettings!
    var gameController: GameController!
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .background
        
        draw()
    }
    
    func oneMoreChange() {
        HapticsService.shared.play(.heavy)
        
        if let ad = RewardedAd.shared.rewardedAd {
            ad.present(fromRootViewController: self.view?.window?.rootViewController) {
                self.gameController.oneMoreChance = false
                RouterService.shared.navigate(.game)
            }
        }
    }
    
    func tryAgain() {
        HapticsService.shared.play(.heavy)
        gameController.save()
        RouterService.shared.navigate(.game)
    }
    
    func goToMenu() {
        HapticsService.shared.play(.heavy)
        gameController.save()
        RouterService.shared.navigate(.start)
    }
    
    func draw() {
        let adButton = ButtonNode(imageNamed: "one_more_chance") {
            self.oneMoreChange()
        }
        adButton.size = CGSize(width: 260, height: 60)
        addChild(adButton)
        
        let ad = SKSpriteNode(imageNamed: "ad_button")
        ad.size = CGSize(width: 50, height: 50)
        ad.position = CGPoint(
            x: adButton.size.width / 2,
            y: adButton.size.height / 2
        )
        adButton.addChild(ad)
        
        let tryAgain = ButtonNode(imageNamed: "try_again") {
            self.tryAgain()
        }
        tryAgain.size = CGSize(width: 260, height: 60)
        tryAgain.position.y = adButton.position.y - 80
        addChild(tryAgain)
        
        let menu = ButtonNode(imageNamed: "menu_button") {
            self.goToMenu()
        }
        menu.size = CGSize(width: 260, height: 60)
        menu.position.y = tryAgain.position.y - 80
        addChild(menu)
        
        let title = SKLabelNode(text: "\(gameController.points.formatted()) pts")
        title.position.y = adButton.position.y + 100
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
