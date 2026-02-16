//
//  Plan+Matchable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

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

extension Plan.Section: Matchable {
    
    public var matchStrings: [String] {
        [title].compactMap { $0 }
    }
    
}

public extension Plan.List where Row: Matchable {
    
    // TODO: Avoid duplicating all these inits and functions from Plan.List with addition of just isSearchable.
    
    init(
        isSearchable: Bool = false,
        selection: Binding<String?>,
        sections: [Section]
    ) {
        self.isSearchable = isSearchable
        self.selection = selection
        self.sections = sections
    }
    
    init(
        isSearchable: Bool = false,
        selection: Binding<String?>,
        rows: [Row]
    ) {
        self.init(
            isSearchable: isSearchable,
            selection: selection,
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", rows: rows)
            ]
        )
    }
    
    init(
        isSearchable: Bool = false,
        sections: [Section]
    ) {
        self.isSearchable = isSearchable
        self.selection = nil
        self.sections = sections
    }
    
    init(
        isSearchable: Bool = false,
        rows: [Row]
    ) {
        self.init(
            isSearchable: isSearchable,
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", rows: rows)
            ]
        )
    }
    
    func replacingLastSection(footer: String? = nil) -> Self {
        .init(
            isSearchable: isSearchable,
            sections: sections.dropLast()
                .appendingIfLet(sections.last) { section in
                    [
                        .init(
                            section.title,
                            id: section.id,
                            footer: footer,
                            rows: section.rows
                        )
                    ]
                }
        )
    }
    
}

public extension Plan.SceneConstructor where Row: Matchable {
    
    static func list(
        isSearchable: Bool = false,
        sections: [Section]
    ) -> Self {
        .list(.init(isSearchable: isSearchable, sections: sections))
    }
    
    static func list(
        isSearchable: Bool = false,
        rows: [Row]
    ) -> Self {
        .list(.init(isSearchable: isSearchable, rows: rows))
    }
    
}

// MARK: - Previews

// TODO: Move to public

extension Preview.Row: Matchable {
    public var matchStrings: [String] {
        switch self {
        case .button(let button): [button.title]
        case .detail(let detail): detail.matchStrings
        case .navigationLink(let navigationLink): navigationLink.label.matchStrings
        case .optionalIdentified: []
        case .picker: []
        }
    }
}

private struct Preview: View {
    
    typealias Row = Plan.Row
    typealias List = Plan.List<Row, Scene>
    typealias Scene = Plan.Scene
    
    var list: List {
        .init(
            isSearchable: true,
            sections: [
                .init("First Section") {
                    [
                        .detail("First Row"),
                        .detail("Second Row"),
                    ]
                },
            ]
        )
    }
    
    var body: some View {
        list
    }
}

#Preview {
    NavigationStack {
        Preview()
    }
}
