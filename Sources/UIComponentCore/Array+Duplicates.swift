//
//  Array+Duplicates.swift
//  
//
//  Created by X Tommy on 2023/1/17.
//

import Foundation

public extension Array where Element: Hashable {

    func removingDuplicates() -> [Element] {
        return NSOrderedSet(array: self).array as! [Element]
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
