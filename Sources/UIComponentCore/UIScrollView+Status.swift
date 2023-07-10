//
//  UIScrollView+Status.swift
//
//
//  Created by X Tommy on 2023/1/17.
//

import UIKit

extension UIScrollView {

    public var isTrackingOrDecelerating: Bool {
        isTracking || isDecelerating
    }
}
