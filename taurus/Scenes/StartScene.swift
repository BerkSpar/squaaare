//
//  StartScene.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit
import GoogleMobileAds
import FirebaseAnalytics

class StartScene: SKScene {
    let title = SKLabelNode(text: "SQUAAARE")
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .background
        
        draw()
    }
    
    func play() {
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
        let startButton = ButtonNode(imageNamed: "play_button") {
            self.play()
        }
        startButton.size = CGSize(width: 80, height: 80)
        addChild(startButton)
        
        let shareButton = ButtonNode(imageNamed: "share_button") {
            self.share()
        }
        shareButton.position.x = startButton.position.x - 80
        shareButton.size = CGSize(width: 60, height: 60)
        addChild(shareButton)
        
        let leaderboardButton = ButtonNode(imageNamed: "leaderboard_button") {
            self.showLeaderboard()
        }
        leaderboardButton.size = CGSize(width: 60, height: 60)
        leaderboardButton.position.x = leaderboardButton.position.x + 80
        addChild(leaderboardButton)
        
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
