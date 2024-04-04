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
        }
    }
}
