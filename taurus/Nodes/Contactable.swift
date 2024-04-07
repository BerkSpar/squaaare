//
//  PowerUp.swift
//  taurus
//
//  Created by Felipe Passos on 07/04/24.
//

import SpriteKit

protocol Contactable {
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact)
}
