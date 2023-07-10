//
//  Array+Duplicates.swift
//
//
//  Created by X Tommy on 2023/1/17.
//

import Foundation

extension Array where Element: Hashable {

    public func removingDuplicates() -> [Element] {
        return NSOrderedSet(array: self).array as! [Element]
    }

    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
