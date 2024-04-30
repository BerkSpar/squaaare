//
//  ContentView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import GoogleMobileAds
import FirebaseAuth
import Adjust


enum Screen {
    case start
    case game
    case endGame
}

struct ContentView: View {
    @StateObject var router = RouterService.shared
    
    func initializeApp() {
        RewardedAd.shared.loadAd(withAdUnitId: AdService.rewardedId)
        InterstitialAd.shared.loadAd(withAdUnitId: AdService.posGameIntersticalId)
        
        GameService.shared.authenticate { error in
            GameCenterAuthProvider.getCredential() { (credential, error) in
                if error != nil {
                    return
                }
                
                Auth.auth().signIn(with:credential!) { (user, error) in
                    
                }
            }
        }
        
        let event = ADJEvent(eventToken: "lqxg2h")
        Adjust.trackEvent(event)
        
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
