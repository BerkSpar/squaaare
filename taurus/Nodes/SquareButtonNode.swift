//
//  ButtonNode.swift
//  taurus
//
//  Created by Felipe Passos on 23/03/24.
//

import SpriteKit

class SquareButtonNode: SKSpriteNode {
    var tapClosure: (() -> Void)? = nil
    
    private let buttonName: String
    
    init(name: String, tapClosure: @escaping () -> Void) {
        self.tapClosure = tapClosure
        self.buttonName = name
    
        let texture = SKTexture(imageNamed: "\(self.buttonName)_button_up")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonName = "unamed";
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        texture = SKTexture(imageNamed: "\(self.buttonName)_button_down")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        texture = SKTexture(imageNamed: "\(self.buttonName)_button_up")
        
        HapticsService.shared.play(.light)
        
        run(.sequence([
            .wait(forDuration: 0.2),
            .run {
                self.tapClosure?()
            }
        ]))
    }
}
