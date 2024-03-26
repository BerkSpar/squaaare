//
//  ContentView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import GoogleMobileAds

enum Screen {
    case start
    case game
    case endGame
}

struct ContentView: View {
    @StateObject var router = RouterService.shared
    
    func initializeApp() {
        GADMobileAds.sharedInstance().start()
        GADMobileAds.sharedInstance().disableSDKCrashReporting()
        
        RewardedAd.shared.loadAd(withAdUnitId: AdService.rewardedId)
        InterstitialAd.shared.loadAd(withAdUnitId: AdService.intersticalId)
        
        GameService.shared.authenticate { error in
            
        }
    }
    
    var body: some View {
        ZStack {
            switch(router.screen) {
            case .start: StartView()
            case .game: GameView()
            case .endGame: EndGameView()
            }
        }
        .alert(isPresented: $router.isAlertPresented) {
            router.alert
        }
        .sheet(isPresented: $router.isSheetPresented) {
            router.sheet
        }
        .task {
            initializeApp()
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
