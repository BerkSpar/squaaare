//
//  EndGameView.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SwiftUI
import SpriteKit
import StoreKit

struct EndGameView: View {
    var scene: EndGameScene {
        let scene = EndGameScene()
                
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
        }
        .onAppear {
            if #available(iOS 16.0, *) {
                ReviewService().requestReview()
            }
        }
    }
}

#Preview {
    EndGameView()
}
