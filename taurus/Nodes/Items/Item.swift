//
//  ItemNode.swift
//  taurus
//
//  Created by Felipe Passos on 20/03/24.
//

import SpriteKit

protocol Item: Contactable {
    var spawnTimeRange: ClosedRange<TimeInterval> { get }
    var levelRange: ClosedRange<Int> { get }
    var velocity: Double { get }
    var id: String { get }
    
    func draw() -> SKNode
    func configureCollision()
    func spawn(_ scene: GameScene)
    func clone() -> Item
}

protocol Enemy: Item {
    
}
