//
//  StoreView.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    @ObservedObject var service = SubscriptionService.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        RouterService.shared.back()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                            
                            Text("back")
                                .foregroundStyle(.white)
                        }
                    }

                    
                    Spacer()
                    
                    HStack {
                        Image("yellow_coin")
                        
                        Text(PlayerDataManager.shared.playerData.coins.formatted())
                            .foregroundStyle(.white)
                    }
                    
                    HStack {
                        Image("blue_coin")
                        
                        Text(PlayerDataManager.shared.playerData.blueCoins.formatted())
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(hex: 0x2F2F2F))
                
                Text("STOOORE")
                    .foregroundStyle(.white)
            }
            
            ZStack {
                Image("grid_background")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack {
                        ForEach(service.products.filter({ product in
                            product.id.contains("basic") && !service.purchasedProductIDs.contains(product.id)
                        })) { product in
                            Button {
                                Task {
                                    await service.buyProduct(product)
                                }
                            } label: {
                                ZStack {
                                    Image("basic.starter_pack")
                                        .resizable()
                                        .scaledToFit()
                                        .overlay {
                                            
                                            VStack {
                                                Spacer()
                                                
                                                HStack {
                                                    Spacer()
                                                    
                                                    Text(product.displayPrice)
                                                        .foregroundStyle(.black)
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 8)
                                                        .background(.white)
                                                }
                                            }
                                        }
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 24)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    if (service.products.contains(where: { product in
                        product.id.contains("powerup")
                    })) {
                        HStack {
                            Rectangle()
                                .frame(height: 10)
                                .foregroundStyle(.white)
                            
                            Text("POWER-UPS")
                                .foregroundStyle(.white)
                            
                            Rectangle()
                                .frame(height: 10)
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                    }
                    
                    LazyVGrid(
                        columns: [GridItem(spacing: 16), GridItem()],
                        spacing: 16,
                        content: {
                            ForEach(service.products.filter({ product in
                                product.id.contains("powerup")
                            })) { product in
                                Button {
                                    Task {
                                        await service.buyProduct(product)
                                    }
                                } label: {
                                    VStack(spacing: 0){
                                        VStack {
                                            Spacer()
                                            
                                            Image(product.id)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundStyle(.white)
                                            
                                            Spacer()
                                            
                                            Text(product.displayName)
                                                .foregroundStyle(.white)
                                                .padding(.bottom, 8)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color(hex: 0xFF5704))
                                        .padding(8)
                                        
                                        Text(product.displayPrice)
                                            .foregroundStyle(.black)
                                            .padding(.bottom, 8)
                                    }
                                    .frame(height: 160)
                                    .background(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                    })
                    .padding(.horizontal, 24)
                }
            }
        }
        .task {
            await SubscriptionService.shared.loadProducts()
        }
        
    }
}

#Preview {
    StoreView()
}
