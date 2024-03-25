//
//  ItemNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

protocol Item {
    var spawnTimeRange: ClosedRange<TimeInterval> { get }
    var levelRange: ClosedRange<Int> { get }
    var velocity: Double { get }
    var id: String { get }
    
    func didContact(_ scene: GameScene, _ contact: SKPhysicsContact)
    func draw()
    func configureCollision()
    func spawn(_ scene: GameScene)
    func clone() -> Item
}
