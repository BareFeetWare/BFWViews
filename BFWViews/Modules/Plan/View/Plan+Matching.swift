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

extension Plan.Cell: Matchable where Row == Plan.Row {
    public var matchStrings: [String] {
        switch row {
        case .detail(let detailRow):
            detailRow.matchStrings
            // TODO: Implement for any.
        default:
            []
        }
    }
}

extension Plan.Section: Matchable where Row: Matchable {
    
    public var matchStrings: [String] {
        [title].compactMap { $0 }
    }
    
    public func matching(searchString: String) -> Self? {
        isMatching(searchString: searchString)
        || searchString.isEmpty
        ? self
        : cells
            .filter { $0.row.isMatching(searchString: searchString) }
            .nilIfEmpty
            .map { .init(title, footer: footer, cells: $0) }
    }
}

public extension Plan.List where Row: Matchable {
    func matching(searchString: String) -> Self {
        .init(sections: sections.compactMap { $0.matching(searchString: searchString) })
    }
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
