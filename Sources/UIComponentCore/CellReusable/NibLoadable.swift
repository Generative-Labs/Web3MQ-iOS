//
//  NibLoadable.swift
//
//
//  Created by X Tommy on 2023/1/16.
//

import UIKit

public protocol NibLoadable: AnyObject {

    static var nib: UINib { get }
}

extension NibLoadable {

    public static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibLoadable where Self: UIView {

    public static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}
