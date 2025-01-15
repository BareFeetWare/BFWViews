//
//  Titled.swift
//
//  Created by Tom Brodhurst-Hill on 31/12/2023.
//

import Foundation

public protocol Titled {
    var title: String { get }
}

extension String: Titled {
    public var title: String { self }
}
