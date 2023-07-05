//
//  UIFont+Descriptor.swift
//  
//
//  Created by X Tommy on 2023/1/16.
//

import UIKit

public extension UIFont {

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)  //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    func italicBold() -> UIFont {
        return withTraits(traits: [.traitBold, .traitItalic])
    }

}
