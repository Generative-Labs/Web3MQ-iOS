//
//  ColorPalette.swift
//
//
//  Created by X Tommy on 2023/7/17.
//

import UIKit

///
public protocol ColorPalette {

    ///
    var name: String { get }

    ///
    var accentColor: UIColor { get }

    ///
    var labelColor: UIColor { get }

    ///
    var secondaryLabelColor: UIColor { get }

    ///
    var tertiaryLabelColor: UIColor { get }

    ///
    var backgroundColor: UIColor { get }

    ///
    var secondaryBackgroundColor: UIColor { get }

    ///
    var tertiaryBackgroundColor: UIColor { get }

    ///
    var diverColor: UIColor { get }

    ///
    var errorColor: UIColor { get }

}

public struct Web3MQColorPalette: ColorPalette {

    public var name: String = "Web3MQ Default Color Palette"

    public init() {}

    ///
    public var accentColor: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(
                    displayP3Red: 56 / 255.0, green: 30 / 255.0, blue: 171 / 255.0, alpha: 1)
            } else {
                return UIColor(
                    displayP3Red: 102 / 255.0, green: 60 / 255.0, blue: 238 / 255.0, alpha: 1)
            }
        }
    }

    ///
    public var labelColor: UIColor {
        UIColor.label
    }

    ///
    public var secondaryLabelColor: UIColor {
        UIColor.secondaryLabel
    }

    ///
    public var tertiaryLabelColor: UIColor {
        UIColor.tertiaryLabel
    }

    ///
    public var backgroundColor: UIColor {
        UIColor.systemBackground
    }

    ///
    public var secondaryBackgroundColor: UIColor {
        UIColor.secondarySystemBackground
    }

    ///
    public var tertiaryBackgroundColor: UIColor {
        UIColor.tertiarySystemBackground
    }

    ///
    public var diverColor: UIColor {
        UIColor.separator
    }

    ///
    public var errorColor: UIColor {
        UIColor.systemRed
    }

}
