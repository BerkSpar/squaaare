//
//  Start.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import GoogleMobileAds
import SpriteKit

struct StartView: View {    
    var scene: SKScene {
        let scene = StartScene()
                
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    @State var height: CGFloat = 0 //Height of ad
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
        ZStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
            
            if (ConfigService.shared.showStartBanner) {
                VStack {
                    Spacer()
                    
                    BannerAd(adUnitId: AdService.gameView)
                        .frame(width: width, height: height, alignment: .center)
                        .onAppear {
                            setFrame()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                            setFrame()
                        }
                }
            }
            
        }
        .onAppear {
            GameService.shared.showAccessPoint()
        }
        .onDisappear {
            GameService.shared.hideAccessPoint()
        }
    }
}

#Preview {
    StartView()
}
