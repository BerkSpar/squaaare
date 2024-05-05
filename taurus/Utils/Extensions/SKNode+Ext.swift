//
//  SKNode+Ext.swift
//  taurus
//
//  Created by Felipe Passos on 06/04/24.
//

import SpriteKit

extension SKNode
{
    func glow(radius:CGFloat=30, yPosition:CGFloat=0)
    {
        let view = SKView()
        let effectNode = SKEffectNode()
        let texture = view.texture(from: self)
        effectNode.shouldRasterize = true
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
        effectNode.position.y = yPosition
        effectNode.zPosition = self.zPosition - 1
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        
    }
}
