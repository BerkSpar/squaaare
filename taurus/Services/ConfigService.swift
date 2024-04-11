//
//  RemoteConfigService.swift
//  taurus
//
//  Created by Felipe Passos on 04/04/24.
//

import FirebaseRemoteConfig

class ConfigService {
    static let shared = ConfigService()
    
    var rotateCharacter: Bool = true
    var showGameBanner: Bool = false
    var enableChocoOz: Bool = false
    
    func start() {
        #if DEBUG
            let fetchDuration: TimeInterval = 0
        #else
            let fetchDuration: TimeInterval = 10
        #endif
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
            if error != nil {
              return
            }
            
            RemoteConfig.remoteConfig().activate()
            
            self.rotateCharacter = RemoteConfig.remoteConfig().configValue(forKey: "rotate_character").boolValue
            self.showGameBanner = RemoteConfig.remoteConfig().configValue(forKey: "show_game_banner").boolValue
            self.showGameBanner = RemoteConfig.remoteConfig().configValue(forKey: "enable_choco_oz").boolValue
        }
    }
}
