//
//  Plan+Matching.swift
//  Power
//
//  Created by Tom Brodhurst-Hill on 8/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import Foundation

public protocol Matchable {
    var matchStrings: [String] { get }
}

public extension Matchable {
    
    func isMatching(searchString: String) -> Bool {
        matchStrings
            .compactMap { $0 }
            .contains { string in
                string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || string.lowercased().contains(searchString.lowercased())
            }
    }
    
}

extension Plan.DetailRow: Matchable {
    public var matchStrings: [String] {
        [title, subtitle, trailing]
            .compactMap { $0 }
    }
}

extension Plan.Cell: Matchable {
    public var matchStrings: [String] {
        switch self {
        case .detail(let row):
            row.matchStrings
        case .push(let push):
            push.row.matchStrings
            // TODO: Implement for any.
        default:
            []
        }
    }
}

extension Plan.Section: Matchable where Cell: Matchable {
    
    public var matchStrings: [String] {
        [title].compactMap { $0 }
    }
    
    public func matching(searchString: String) -> Self? {
        isMatching(searchString: searchString)
        || searchString.isEmpty
        ? self
        : cells
            .filter { $0.isMatching(searchString: searchString) }
            .nilIfEmpty
            .map { .init(title, footer: footer, cells: $0) }
    }
}

public extension Array {
    func matching<Cell: Matchable>(searchString: String) -> Self
    where Element == Plan.Section<Cell>
    {
        compactMap { $0.matching(searchString: searchString) }
    }
}

public extension Plan.List where Cell: Matchable {
    func matching(searchString: String) -> Self {
        .init(sections: sections.matching(searchString: searchString))
    }
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
