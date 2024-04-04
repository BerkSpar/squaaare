//
//  ContentView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import GoogleMobileAds
import FirebaseAuth


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
        
        GameService.shared.authenticate { error in
            GameCenterAuthProvider.getCredential() { (credential, error) in
                if let error = error {
                    return
                }
                
                Auth.auth().signIn(with:credential!) { (user, error) in
                    if let error = error {
                        return
                    }
                    
                    
                }
            }
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
