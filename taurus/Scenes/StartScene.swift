//
//  StartScene.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit
import GoogleMobileAds
import FirebaseAnalytics
import FacebookCore

class StartScene: SKScene {
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black
                
        draw()
    }
    
    func play() {
        AppEvents.shared.logEvent(AppEvents.Name("FB-Play"))
        RouterService.shared.navigate(.game)
    }
    
    func share() {
        let postText: String = "Check out my score on Squaaare! Can you beat it?\n\nhttps://apps.apple.com/br/app/squaaare/id6479618727"
        let activityItems = [postText]
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        activityController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            GameService.shared.showAccessPoint()
            
            Analytics.logEvent(AnalyticsEventShare, parameters: nil)
         }

        let controller: UIViewController = scene!.view!.window!.rootViewController!
        
        controller.present(
            activityController,
            animated: true,
            completion: {
                GameService.shared.hideAccessPoint()
            }
        )
    }
    
    func showLeaderboard() {
        GameService.shared.showLeaderboard()
    }
    
    func draw() {
        let background = SKSpriteNode(imageNamed: "grid_background")
        background.size = frame.size
        background.zPosition = -1
        addChild(background)
        
        let startButton = SquareButtonNode(name: "play") {
            self.play()
        }
        startButton.size = CGSize(width: 80, height: 80)
        startButton.glow()
        addChild(startButton)
        
        startButton.run(.repeatForever(.sequence([
            .scale(to: 1.1, duration: 0.3),
            .scale(by: 0.9, duration: 0.3)
        ])))
        
        let trophyButton = SquareButtonNode(name: "trophy") {
            self.showLeaderboard()
        }
        trophyButton.size = CGSize(width: 60, height: 60)
        trophyButton.position = startButton.position
        trophyButton.position.y -= 90
        trophyButton.glow()
        addChild(trophyButton)
        
        let shopButton = SquareButtonNode(name: "shop") {
            RouterService.shared.navigate(.store)
        }
        shopButton.size = CGSize(width: 60, height: 60)
        shopButton.position = trophyButton.position
        shopButton.position.y -= 80
        shopButton.glow()
        addChild(shopButton)
        
        let title = SKSpriteNode(imageNamed: "logo")
        title.position.y = startButton.position.y + 120
        title.glow()
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
