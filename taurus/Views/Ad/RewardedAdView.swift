//
//  RewardedAdView.swift
//  telly
//
//  Created by Felipe Passos on 23/09/23.
//

import UIKit
import SwiftUI
import GoogleMobileAds

class RewardedAd: NSObject {
    var rewardedAd: GADRewardedAd?
    
    static let shared = RewardedAd()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADRewardedAd.load(withAdUnitID: id, request: req) { rewardedAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                return
            }
            
            self.rewardedAd = rewardedAd
        }
    }
}

struct RewardedAdView: UIViewControllerRepresentable {
    
    let rewardedAd = RewardedAd.shared.rewardedAd
    @Binding var isPresented: Bool
    let adUnitId: String
    let rewardFunc: (() -> Void)
    
    init(isPresented: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void)) {
        self._isPresented = isPresented
        self.adUnitId = adUnitId
        self.rewardFunc = rewardFunc
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = UIViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.showAd(from: view)
        }
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    func showAd(from root: UIViewController) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: root) {
                // This calls the reward function once the ad has been played for long enough
                self.rewardFunc()
                
//                RewardedAd.shared.rewardedAd = nil
            }
        } else {
            print("Ad not ready")
            self.isPresented.toggle()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GADFullScreenContentDelegate {
        var parent: RewardedAdView

        init(_ parent: RewardedAdView) {
            self.parent = parent
            super.init()
            parent.rewardedAd?.fullScreenContentDelegate = self
        }

        // Implement the GADFullScreenContentDelegate methods here
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            RewardedAd.shared.loadAd(withAdUnitId: parent.adUnitId)

            parent.isPresented.toggle()
        }
    }
}
