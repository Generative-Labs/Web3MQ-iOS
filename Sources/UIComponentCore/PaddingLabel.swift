//
//  PaddingLabel.swift
//  
//
//  Created by X Tommy on 2023/1/18.
//

import UIKit

open class PaddingLabel: UILabel {

    @IBInspectable
    public var textInsets: UIEdgeInsets = .zero
  
    override public func drawText(in rect: CGRect) {
        let insets = textInsets
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.width += (textInsets.left + textInsets.right)
            contentSize.height += (textInsets.top + textInsets.bottom)
            return contentSize
        }
    }
}

