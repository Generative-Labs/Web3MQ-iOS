//
//  Utils.swift
//
//
//  Created by X Tommy on 2023/1/11.
//

import UIKit

extension CGFloat {
    static var onePixel: CGFloat {
        let scale = UIScreen.main.scale
        return 1 / (scale > 0 ? scale : 1)
    }
    var half: CGFloat { return (self / 2) }
}

extension UIColor {

    // rgba(228, 228, 231, 1)
    static var border: UIColor {
        UIColor(displayP3Red: 228 / 256.0, green: 228 / 256.0, blue: 231 / 256.0, alpha: 1)
    }

    static var accent: UIColor? {
        UIColor(named: "AccentColor")
    }

}
