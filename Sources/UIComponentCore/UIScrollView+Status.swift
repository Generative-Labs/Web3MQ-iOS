//
//  UIScrollView+Status.swift
//  
//
//  Created by X Tommy on 2023/1/17.
//

import UIKit

public extension UIScrollView {
    
    var isTrackingOrDecelerating: Bool {
        isTracking || isDecelerating
    }
}
