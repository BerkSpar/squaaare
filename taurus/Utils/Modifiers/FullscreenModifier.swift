//
//  FullscreenModifier.swift
//  telly
//
//  Created by Felipe Passos on 23/09/23.
//

import SwiftUI

struct FullScreenModifier<Parent: View>: View {
    @Binding var isPresented: Bool
    @State var adType: AdType
    
    //Select adType
    enum AdType {
        case interstitial
        case rewarded
    }
    
    var rewardFunc: () -> Void
    var adUnitId: String
  
    //The parent is the view that you are presenting over
    //Think of this as your presenting view controller
    var parent: Parent
    
    var body: some View {
        ZStack {
            parent
            
            if isPresented {
                EmptyView()
                    .edgesIgnoringSafeArea(.all)
                
                if adType == .rewarded {
                    RewardedAdView(isPresented: $isPresented, adUnitId: adUnitId, rewardFunc: rewardFunc)
                        .edgesIgnoringSafeArea(.all)
                } else if adType == .interstitial {
                    InterstitialAdView(isPresented: $isPresented, adUnitId: adUnitId)
                }
            }
        }
        .onAppear {
            //Initialize the ads as soon as the view appears
            if adType == .rewarded {
                RewardedAd.shared.loadAd(withAdUnitId: adUnitId)
            } else if adType == .interstitial {
                InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
            }
        }
    }
}
