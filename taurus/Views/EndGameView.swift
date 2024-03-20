//
//  EndGameView.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SwiftUI

struct EndGameView: View {
    @State var showRewardedAd: Bool = false
    @State var showInterstitialAd: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Watch an Ad to return") {
                HapticsService.shared.play(.heavy)
                
                showRewardedAd.toggle()
            }
            
            Button("End Game") {
                HapticsService.shared.play(.heavy)
                
                GameController.shared.reset()
                
                showInterstitialAd.toggle()
                
                RouterService.shared.navigate(.start)
            }
            
            Spacer()
        }
        .presentRewardedAd(
            isPresented: $showRewardedAd,
            adUnitId: AdService.rewardedId
        ) {
            RouterService.shared.navigate(.game)
        }
        .presentInterstitialAd(isPresented: $showInterstitialAd, adUnitId: AdService.intersticalId)
    }
}

#Preview {
    EndGameView()
}
