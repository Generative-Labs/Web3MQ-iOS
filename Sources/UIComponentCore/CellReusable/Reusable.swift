//
//  CellReusable.swift
//
//
//  Created by X Tommy on 2023/1/16.
//

import Foundation

public protocol Reusable: AnyObject {

    static var reuseIdentifier: String { get }
}

public typealias NibReusable = Reusable & NibLoadable

extension Reusable {

    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
