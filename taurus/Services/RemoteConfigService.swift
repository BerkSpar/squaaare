//
//  RemoteConfigService.swift
//  taurus
//
//  Created by Felipe Passos on 04/04/24.
//

import FirebaseRemoteConfig

class ConfigService {
    static let shared = ConfigService()
    
    var remoteConfig: RemoteConfig?
    
    var rotateCharacter: Bool = true
    
    func start() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        
        #if DEBUG
            let fetchDuration: TimeInterval = 0
        #else
            let fetchDuration: TimeInterval = 10
        #endif
        
        remoteConfig?.fetch(withExpirationDuration: fetchDuration) { status, error in
            if error != nil {
              return
            }
            
            self.remoteConfig?.activate()
            
            self.rotateCharacter = self.remoteConfig?.configValue(forKey: "rotate_character").boolValue ?? self.rotateCharacter
        }
    }
}
