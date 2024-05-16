//
//  GameView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import GoogleMobileAds
import SpriteKit

struct GameView: View {
    @State var height: CGFloat = 67 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    
    func setFrame() {
        //Get the frame of the safe area
        let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        //Use the frame to determine the size of the ad
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        
        //Set the ads frame
        self.width = adSize.size.width
        self.height = adSize.size.height
    }
    
    var scene: SKScene {
        let scene = GameScene()
                
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - height
        )
        
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
            
            if (ConfigService.shared.showGameBanner && PlayerDataManager.shared.playerData.showAds) {
                VStack(spacing: 0) {
                    Rectangle()
                        .padding(.zero)
                        .frame(maxWidth: .infinity, maxHeight: 2)
                    
                    BannerAd(adUnitId: AdService.gameView)
                        .frame(width: width, height: height, alignment: .center)
                        .onAppear {
                            setFrame()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                            setFrame()
                        }
                        .background(.black)
                }
            }
        }
    }
}

#Preview {
    GameView()
}
