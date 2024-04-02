//
//  ReviewService.swift
//  taurus
//
//  Created by Felipe Passos on 31/03/24.
//

import StoreKit
import Foundation
import SwiftUI

@available(iOS 16.0, *)
class ReviewService {
    @Environment(\.requestReview) var requestReview
    
    private let userDefaultsKey = "has_reviewd"
    
    @MainActor func review() {
        if !UserDefaults.standard.bool(forKey: userDefaultsKey) {
            requestReview()
            
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
    }
}
