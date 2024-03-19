//
//  IntersticalAdView.swift
//  telly
//
//  Created by Felipe Passos on 23/09/23.
//

import SwiftUI
import UIKit
import GoogleMobileAds

class InterstitialAd: NSObject {
    var interstitialAd: GADInterstitialAd?
    
    static let shared = InterstitialAd()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { interstitialAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                return
            }
            self.interstitialAd = interstitialAd
        }
    }
}

struct InterstitialAdView: UIViewControllerRepresentable {
    let interstitialAd = InterstitialAd.shared.interstitialAd
    @Binding var isPresented: Bool
    var adUnitId: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = UIViewController()
        
        // Show the ad after a slight delay to ensure the ad is loaded and ready to present
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            context.coordinator.showAd(from: view)
        }
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    class Coordinator: NSObject, GADFullScreenContentDelegate {
        var parent: InterstitialAdView

        init(_ parent: InterstitialAdView) {
            self.parent = parent
            super.init()
            parent.interstitialAd?.fullScreenContentDelegate = self
        }

        // Presents the ad if it can, otherwise dismisses so the user's experience is not interrupted
        func showAd(from root: UIViewController) {
            if let ad = parent.interstitialAd {
                ad.present(fromRootViewController: root)
            } else {
                print("Ad not ready")
                parent.isPresented.toggle()
            }
        }

        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            // Prepares another ad for the next time view presented
            InterstitialAd.shared.loadAd(withAdUnitId: parent.adUnitId)
            
            // Dismisses the view once ad dismissed
            parent.isPresented.toggle()
        }
    }
}
