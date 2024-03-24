//
//  EndGameView.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SwiftUI
import SpriteKit

class AdSettings: ObservableObject {
    @Published var showRewardedAd: Bool = false
    @Published var showInterstitialAd: Bool = false
}

struct EndGameView: View {
    @ObservedObject var adSettings = AdSettings()
    @ObservedObject var gameController = GameController.shared
    
    var scene: EndGameScene {
        let scene = EndGameScene()
        
        scene.adSettings = adSettings
        scene.gameController = gameController
                
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    EndGameView()
}
