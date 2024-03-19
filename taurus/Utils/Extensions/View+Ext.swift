//
//  View+Ext.swift
//  telly
//
//  Created by Felipe Passos on 24/08/23.
//

import Foundation
import SwiftUI

extension View {
    /// Aplies rounded corner to any side you want.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    public func presentRewardedAd(isPresented: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void)) -> some View {
        FullScreenModifier(isPresented: isPresented, adType: .rewarded, rewardFunc: rewardFunc, adUnitId: adUnitId, parent: self)
    }
    
    public func presentInterstitialAd(isPresented: Binding<Bool>, adUnitId: String) -> some View {
        FullScreenModifier(isPresented: isPresented, adType: .interstitial, rewardFunc: {}, adUnitId: adUnitId, parent: self)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
