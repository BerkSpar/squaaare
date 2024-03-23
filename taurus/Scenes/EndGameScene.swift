//
//  EndGameScene.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit
import SwiftUI

class EndGameScene: SKScene {
    var adSettings: AdSettings!
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .background
        
        draw()
    }
    
    func oneMoreChange() {
        HapticsService.shared.play(.heavy)
        self.adSettings.showRewardedAd.toggle()
    }
    
    func tryAgain() {
        HapticsService.shared.play(.heavy)
        GameController.shared.save()
        RouterService.shared.navigate(.game)
    }
    
    func draw() {
        let startButton = ButtonNode(imageNamed: "one_more_chance") {
            self.oneMoreChange()
        }
        startButton.size = CGSize(width: 260, height: 60)
        addChild(startButton)
        
        let tryAgain = ButtonNode(imageNamed: "try_again") {
            self.tryAgain()
        }
        tryAgain.size = CGSize(width: 260, height: 60)
        tryAgain.position.y = startButton.position.y - 80
        addChild(tryAgain)
        
        let title = SKLabelNode(text: "\(GameController.shared.points.formatted()) pts")
        title.position.y = startButton.position.y + 100
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
