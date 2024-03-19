//
//  GameView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import GoogleMobileAds

struct GameView: View {
    @State var height: CGFloat = 0 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    
    @State var showRewardedAd: Bool = false
    @State var showInterstitialAd: Bool = false
    
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
            Spacer()
            
            Text("GameView")
            
            Button("Power Up") {
                HapticsService.shared.play(.heavy)
                
                showRewardedAd.toggle()
            }
            
            Button("End Game") {
                HapticsService.shared.play(.heavy)
                
                showInterstitialAd.toggle()
                
                RouterService.shared.navigate(.start)
            }
            
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
        .presentRewardedAd(
            isPresented: $showRewardedAd,
            adUnitId: AdService.rewardedId
        ) {
            // do things
        }
        .presentInterstitialAd(isPresented: $showInterstitialAd, adUnitId: AdService.intersticalId)
    }
}

#Preview {
    GameView()
}
