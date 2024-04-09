//
//  AdService.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import Foundation

class AdService: ObservableObject {
    #if DEBUG
        static let gameView = "ca-app-pub-3940256099942544/9214589741"
        static let rewardedId = "ca-app-pub-3940256099942544/5224354917"
        static let intersticalId = "ca-app-pub-3940256099942544/1033173712"
        static let startBannerId = "ca-app-pub-3940256099942544/9214589741"
        static let endGameBannerId = "ca-app-pub-3940256099942544/9214589741"
        static let posGameIntersticalId = "ca-app-pub-3940256099942544/1033173712"
    #else
        static let gameView = "ca-app-pub-2005622694052245/3042641245"
        static let rewardedId = "ca-app-pub-2005622694052245/1653940901"
        static let intersticalId = "ca-app-pub-2005622694052245/4628223062"
        static let startBannerId = "ca-app-pub-2005622694052245/4197752308"
        static let endGameBannerId = "ca-app-pub-2005622694052245/6044019159"
        static let posGameIntersticalId = "ca-app-pub-2005622694052245/3347705069"
    #endif
}
