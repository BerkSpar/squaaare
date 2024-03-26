//
//  SKScene+Ext.swift
//  taurus
//
//  Created by Felipe Passos on 26/03/24.
//

import Foundation

import Foundation
import SpriteKit

extension SKScene {
    func sceneShake(shakeCount: Int, intensity: CGVector, shakeDuration: Double) {
        let sceneView = self.scene!.view! as UIView
        let shakeAnimation = CABasicAnimation(keyPath: "position")

        shakeAnimation.duration = shakeDuration / Double(shakeCount)
        shakeAnimation.repeatCount = Float(shakeCount)
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: sceneView.center.x - intensity.dx, y: sceneView.center.y - intensity.dy))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: sceneView.center.x + intensity.dx, y: sceneView.center.y + intensity.dy))

        sceneView.layer.add(shakeAnimation, forKey: "position")
    }
    
    func simpleShake() {
        sceneShake(shakeCount: 3, intensity: CGVector(dx: 3, dy: 1), shakeDuration: 0.3)
    }
    
    func bombShake() {
        sceneShake(shakeCount: 10, intensity: CGVector(dx: 12, dy: 6), shakeDuration: 0.3)
    }
}
