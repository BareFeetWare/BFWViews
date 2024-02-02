//
//  Plan.List.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan {
    struct List {
        
        public init(
            sections: [Section?]
        ) {
            self.sections = sections
        }
        
        public let sections: [Section?]
    }
}

// MARK: - Convenience Inits

public extension Plan.List {
    
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
    
    func wrappingCellsInButton(action: @escaping (Plan.Cell) -> Void) -> Plan.List {
        .init(
            sections: sections.compactMap { $0 }
                .map { section in
                Plan.Section(
                    id: section.id,
                    isExpanded: section.isExpanded,
                    header: section.header,
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

extension Plan.List {
    static let preview = Plan.List(
        sections: [
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
    
    static func asyncChildrenScene() async throws -> some View {
        // Arbitrary delay, pretending to be an async request.
        try await Task.sleep(nanoseconds: 2000000000)
        return childrenScene
    }
    
    static var childrenScene: some View {
        Plan.List(
            cells: [
                .detail("Child 1"),
                .detail("Child 2"),
                .detail("Child 3"),
            ]
        )
    }
    
}
