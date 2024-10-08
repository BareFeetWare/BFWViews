//
//  Plan.List.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan {
    struct List<Selection: Hashable> {
        
        public init(
            selection: Binding<Selection?>? = nil,
            sections: [Section?]
        ) {
            self.selection = selection
            self.sections = sections
        }
        
        public let selection: Binding<Selection?>?
        public let sections: [Section?]
    }
}

// MARK: - Convenience Inits

public extension Plan.List {
    
    init(
        selection: Binding<Selection?>,
        sections: [Plan.Section?]
    ) {
        self.selection = selection
        self.sections = sections
    }
    
    init(
        selection: Binding<Selection?>,
        cells: [Plan.Cell?]
    ) {
        self.init(
            selection: selection,
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", cells: cells)
            ]
        )
    }
    
}

public extension Plan.List where Selection == String {
    
    init(
        sections: [Plan.Section?]
    ) {
        self.selection = nil
        self.sections = sections
    }
    
    init(
        cells: [Plan.Cell?]
    ) {
        self.init(
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collpasing DisclosureGroup.
                .init(id: "only one section", cells: cells)
            ]
        )
    }
    
}

// MARK: - Modifiers

public extension Plan.List {
    
    func wrappingCellsInButton(
        action: @escaping (Plan.Cell) -> Void
    ) -> Plan.List<Selection> {
        .init(
            selection: selection,
            sections: sections.compactMap { $0 }
                .map { section in
                Plan.Section(
                    id: section.id,
                    isExpanded: section.isExpanded,
                    title: section.title,
                    cells: section.cells.compactMap { $0 }.map { cell in
                        Plan.Cell(id: cell.id) {
                            Button {
                                action(cell)
                            } label: {
                                AnyView(
                                    cell.content()
                                )
                            }
                        }
                    },
                    emptyPlaceholder: section.emptyPlaceholder
                )
            }
        )
    }
}

// MARK: - Previews

extension Plan.List<String> {
    
    struct Preview {
        @State var selectedCellID: String?
        
        var list: Plan.List<String> {
            Plan.List(
                selection: $selectedCellID,
                sections: [
                    .init(
                        title: "selection",
                        cells: [
                            .detail("selection:", trailing: selectedCellID),
                        ]
                    ),
                    .init(
                        title: "Buttons and detail",
                        cells: [
                            .button("Start") {},
                            .detail("Status", trailing: "Off line"),
                            .button("Scan") {},
                        ]
                    ),
                    .init(
                        title: "NavigationLink",
                        cells: [
                            .detail("Children", trailing: "3") {
                                childrenScene
                            }
                        ]
                    ),
                    .init(
                        title: "Async children",
                        cells: [
                            .detail("Children", trailing: "3") {
                                try await asyncChildrenScene()
                            },
                        ]
                    ),
                ]
            )
        }
        
        func asyncChildrenScene() async throws -> some View {
            // Arbitrary delay, pretending to be an async request.
            try await Task.sleep(nanoseconds: 2000000000)
            return childrenScene
        }
        
        var childrenScene: some View {
            Plan.List(
                cells: [
                    .detail("Child 1"),
                    .detail("Child 2"),
                    .detail("Child 3"),
                ]
            )
        }
        
    }
}
