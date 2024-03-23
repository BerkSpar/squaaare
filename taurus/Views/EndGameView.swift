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
    
    var scene: SKScene {
        let scene = EndGameScene()
        
        scene.adSettings = adSettings
                
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        scene.scaleMode = .aspectFit
                
        return scene
    }
    
    var body: some View {
//        VStack {
//            Spacer()
//            
//            Button("Watch an Ad to return") {
//                HapticsService.shared.play(.heavy)
//                
//                showRewardedAd.toggle()
//            }
//            
//            Button("End Game") {
//                HapticsService.shared.play(.heavy)
//                
//                GameController.shared.save()
//                
//                showInterstitialAd.toggle()
//                
//                RouterService.shared.navigate(.start)
//            }
//            
//            Button("Restart Game") {
//                HapticsService.shared.play(.heavy)
//                
//                GameController.shared.save()
//                
//                RouterService.shared.navigate(.game)
//            }
//            
//            Spacer()
//        }
        ZStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
        }
        .presentRewardedAd(
            isPresented: $adSettings.showRewardedAd,
            adUnitId: AdService.rewardedId
        ) {
            RouterService.shared.navigate(.game)
        }
        .presentInterstitialAd(isPresented: $adSettings.showInterstitialAd, adUnitId: AdService.intersticalId)
    }
}

#Preview {
    EndGameView()
}
