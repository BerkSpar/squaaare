//
//  AbilityNode.swift
//  taurus
//
//  Created by Felipe Passos on 04/04/24.
//

import SpriteKit

class AbilityNode: SKNode {
    let imageNamed: String
    let apply: () -> Void
    
    init(imageNamed: String, apply: @escaping () -> Void) {
        self.imageNamed = imageNamed
        self.apply = apply
        super.init()
        draw()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() {
        let node = SKSpriteNode(imageNamed: imageNamed)
        addChild(node)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        run(.sequence([
            .scale(to: 0.9, duration: 0.1),
            .scale(to: 1.1, duration: 0.1),
            .scale(to: 1.0, duration: 0.1),
            .run {
                self.apply()
            }
        ]))
    }
}
