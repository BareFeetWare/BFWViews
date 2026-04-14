//
//  Plan.Node.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/8/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan {
    /// A recursive data node (such as JSON) that can be displayed as Plan rows.
    public protocol Node {
        /// The display string for a leaf node, or nil for collections (array/dictionary/null).
        var singleValueString: String? { get }
        /// The dictionary representation, if this node is a dictionary.
        var asDictionary: [String: Self]? { get }
        /// The array representation, if this node is an array.
        var asArray: [Self]? { get }
    }
}

// MARK: - Functions

public extension Plan.Node {
    
    var summary: String {
        if let string = singleValueString {
            string
        } else if let dictionary = asDictionary {
            "[" + dictionary.keys.sorted().joined(separator: ", ") + "]"
        } else if let array = asArray {
            "Array(\(array.count))"
        } else {
            "null"
        }
    }
    
    var title: String? {
        guard let dictionary = asDictionary else { return nil }
        return ["title", "name", "descriptor", "description"]
            .lazy
            .compactMap { dictionary[$0]?.singleValueString }
            .first
    }
    
    var id: String? {
        asDictionary?["id"]?.singleValueString
    }
}
