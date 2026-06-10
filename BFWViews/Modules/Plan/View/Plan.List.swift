//
//  Plan.List.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan {
    struct List<Row: View, Scene: View> {
        public let isSearchable: Bool
        public let selection: Binding<String?>?
        public let sections: [Section]
        @State var searchString: String = ""
        
        public init(
            isSearchable: Bool = false,
            selection: Binding<String?>? = nil,
            sections: [Section]
        ) {
            self.isSearchable = isSearchable
            self.selection = selection
            self.sections = sections
        }
        
    }
}

// MARK: - Types

public extension Plan.List {
    typealias Section = Plan.Section<Row, Scene>
}

// MARK: - Convenience Inits

public extension Plan.List {
    
    init(
        selection: Binding<String?>,
        sections: [Section]
    ) {
        self.isSearchable = false
        self.selection = selection
        self.sections = sections
    }
    
    init(
        selection: Binding<String?>,
        rows: [Row]
    ) {
        self.init(
            selection: selection,
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", rows: rows)
            ]
        )
    }
    
    init(
        sections: [Section]
    ) {
        self.isSearchable = false
        self.selection = nil
        self.sections = sections
    }
    
    init(
        rows: [Row]
    ) {
        self.init(
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", rows: rows)
            ]
        )
    }
    
}

// MARK: - Functions

extension Plan.List {
    
    var matchingSections: [Section] {
        sections.compactMap { $0.matching(searchString: searchString) }
    }
    
    var sectionsIdentified: [Identified<Section>] {
        matchingSections.identified()
    }
    
    public func replacingLastSection(footer: String? = nil) -> Self {
        .init(
            sections: matchingSections.dropLast()
                .appendingIfLet(sections.last) { section in
                    [
                        .init(
                            section.title,
                            id: section.id,
                            footer: footer,
                            rows: section.rows,
                        )
                    ]
                }
        )
    }
    
}

// MARK: - Views

extension Plan.List: View {
    public var body: some View {
        List(selection: selection) {
            ForEach(sectionsIdentified) { $0 }
        }
        .if(isSearchable) {
            $0.searchable(text: $searchString)
        }
    }
}

// MARK: - Previews

struct PlanListDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Preview()
        }
    }
}

private struct Preview {
    @State var selectedCellID: String?
    typealias List = Plan.List<Plan.Row, Plan.Scene>
    typealias Section = Plan.Section<Plan.Row, Plan.Scene>
}

extension Preview {
    
    var list: List {
        .init(
            selection: $selectedCellID,
            sections: sections
        )
    }
    
    var sections: [Section] {
        [
            .init(
                "selection",
                rows: [
                    .detail("selection:", trailing: selectedCellID),
                ]
            ),
            .init(
                "Buttons and detail",
                rows: [
                    .button("Start") {},
                    .detail("Status", trailing: "Off line"),
                    .button("Scan") {},
                ]
            ),
            .init(
                "NavigationLink",
                rows: [
                    .detail("Children", trailing: "3") {
                        childrenList
                    }
                ]
            ),
            .init(
                "Async children",
                rows: [
                    .detail("Children", trailing: "3") {
                        try await asyncChildrenList()
                    },
                ]
            ),
        ]
    }
    
    func asyncChildrenList() async throws -> List {
        // Arbitrary delay, pretending to be an async request.
        try await Task.sleep(nanoseconds: 2000000000)
        return childrenList
    }
    
    var childrenList: List {
        .init(
            rows: [
                .detail("Child 1"),
                .detail("Child 2"),
                .detail("Child 3"),
            ]
        )
    }
    
}

extension Preview: View {
    var body: some View {
        list
            .navigationBarTitle("Plan.List")
    }
}
