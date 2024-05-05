//
//  EndGameView.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SwiftUI
import SpriteKit
import GoogleMobileAds
import StoreKit

struct EndGameView: View {
    var scene: EndGameScene {
        let scene = EndGameScene()
                
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - height
        )
        
        scene.scaleMode = .fill
        
        return scene
    }
    
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
    
    var body: some View {
        VStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
            
            if (ConfigService.shared.showEndGameBanner && PlayerDataManager.shared.playerData.showAds) {
                VStack(spacing: 0) {
                    Rectangle()
                        .padding(.zero)
                        .frame(maxWidth: .infinity, maxHeight: 2)
                    
                    BannerAd(adUnitId: AdService.endGameBannerId)
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
        .background(.black)
        .onAppear {
            if #available(iOS 16.0, *) {
                ReviewService().reviewIfNeeded()
            }
        }
    }
}

#Preview {
    EndGameView()
}
