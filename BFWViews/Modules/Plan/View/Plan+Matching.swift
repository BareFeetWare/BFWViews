//
//  Scheme+Matching.swift
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

extension Plan.Cell: Matchable {
    public var matchStrings: [String] {
        switch self {
        case .detail(let row):
            [row.title, row.subtitle, row.trailing]
                .compactMap { $0 }
        case .push(let push):
            [push.row.title, push.row.subtitle, push.row.trailing]
                .compactMap { $0 }
            // TODO: Implement for any.
        default:
            []
        }
    }
}
extension Plan.Section: Matchable {
    
    public var matchStrings: [String] {
        [title].compactMap { $0 }
    }
    
    func matching(searchString: String) -> Self? {
        isMatching(searchString: searchString)
        || searchString.isEmpty
        ? self
        : cells
            .filter { $0.isMatching(searchString: searchString) }
            .nilIfEmpty
            .map { .init(title, footer: footer, cells: $0) }
    }
}

extension Array where Element == Plan.Section {
    func matching(searchString: String) -> Self {
        compactMap { $0.matching(searchString: searchString) }
    }
}

extension Plan.List {
    func matching(searchString: String) -> Self {
        .init(sections: sections.matching(searchString: searchString))
    }
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
