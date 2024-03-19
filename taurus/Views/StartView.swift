//
//  Start.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Text("StartView")
            
            Button("Go to Game") {
                RouterService.shared.navigate(.game)
            }
        }
    }
}

#Preview {
    StartView()
}
