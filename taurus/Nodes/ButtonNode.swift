//
//  ButtonNode.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    var tapClosure: (() -> Void)? = nil
    
    init(imageNamed: String, tapClosure: @escaping () -> Void) {
        self.tapClosure = tapClosure
    
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .gray, size: texture.size())
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        run(.sequence([
            .scaleX(to: 0.9, duration: 0.1),
            .scaleX(to: 1.1, duration: 0.1),
            .scaleX(to: 1.0, duration: 0.1),
            .run {
                self.tapClosure?()
            }
        ]))
    }
}
