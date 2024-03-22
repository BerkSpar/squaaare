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
            Spacer()
            
            Image("Item4")
                .resizable()
                .scaledToFit()
                .padding()
            
            ZStack {
                Image("Item3")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                VStack {
                    Button {
                        RouterService.shared.navigate(.game)
                    } label: {
                        ZStack {
                            Image("Item5")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 48)
                            
                            Text("PLAY")
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        GameService.shared.showAchievements()
                    } label: {
                        ZStack {
                            Image("Item5")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 48)
                            
                            Text("ACHIEVEMENTS")
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        GameService.shared.showAchievements()
                    } label: {
                        ZStack {
                            Image("Item5")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 48)
                            
                            Text("LEADERBOARD")
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }

            }
            
            Spacer()
        }
        .background(.white)
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
