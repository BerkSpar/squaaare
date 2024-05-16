//
//  SKLabelNode+Ext.swift
//  taurus
//
//  Created by Felipe Passos on 04/04/24.
//

import SpriteKit

extension SKLabelNode {
   func addStroke(color:UIColor, width: CGFloat) {
        guard let labelText = self.text else { return }

        let font = UIFont(name: self.fontName!, size: self.fontSize)

        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

       let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
   }
    
    func updateAttributedText(_ text: String) {
        if let attributedText = attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.mutableString.setString(text)
            self.attributedText = mutableAttributedText
        }
    }
}
