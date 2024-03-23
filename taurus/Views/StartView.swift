//
//  Start.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import SpriteKit

struct StartView: View {
    var scene: SKScene {
        let scene = StartScene()
                
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
            GameService.shared.showAccessPoint()
        }
        .onDisappear {
            GameService.shared.hideAccessPoint()
        }
    }
}

#Preview {
    StartView()
}
