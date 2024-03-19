//
//  EndGameView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI

struct EndGameView: View {
    var body: some View {
        VStack {
            Text("EndGameView")
            
            Button("Return to Start") {
                RouterService.shared.navigate(.start)
            }
        }
    }
}

#Preview {
    EndGameView()
}
