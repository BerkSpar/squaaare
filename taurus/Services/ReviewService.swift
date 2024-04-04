//
//  ReviewService.swift
//  taurus
//
//  Created by Felipe Passos on 31/03/24.
//

import UIKit
import StoreKit

class ReviewService {
    
    private let userDefaultsKey = "has_reviewed"
    
    func reviewIfNeeded() {
        if !UserDefaults.standard.bool(forKey: userDefaultsKey) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
    }
}
