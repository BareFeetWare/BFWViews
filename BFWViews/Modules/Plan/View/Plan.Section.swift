//
//  Plan.Section.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan {
    public struct Section: OptionalIdentifiable {
        public let id: String?
        public let isExpanded: Binding<Bool>?
        public let title: String?
        public let footer: String?
        public let cells: [Plan.Cell]
        public let emptyPlaceholder: String?
        
        public init(
            // Note: id must not use UUID() which prevents a refreshed section loading as the same instance.
            id: String? = nil,
            isExpanded: Binding<Bool>? = nil,
            title: String? = nil,
            footer: String? = nil,
            cells: [Plan.Cell?],
            emptyPlaceholder: String? = nil
        ) {
            self.id = id
            self.isExpanded = isExpanded
            self.title = title
            self.footer = footer
            self.cells = cells.compactMap { $0 }
            self.emptyPlaceholder = emptyPlaceholder
        }
    }
}

// MARK: - Convenience Inits

public extension Plan.Section {
    
    init(
        _ title: String,
        // Note: id must not use UUID() which prevents a refreshed section loading as the same instance.
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        footer: String? = nil,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
    ) {
        self.id = id
        self.isExpanded = isExpanded
        self.title = title
        self.footer = footer
        self.cells = cells.compactMap { $0 }
        self.emptyPlaceholder = emptyPlaceholder
    }
    
    init(
        _ title: String? = nil,
        id: String? = nil,
        footer: String? = nil,
        cells: [Plan.Cell?]
    ) {
        self.title = title
        self.id = id
        self.footer = footer
        self.cells = cells.compactMap { $0 }
        self.isExpanded = nil
        self.emptyPlaceholder = nil
    }
    
    init(
        _ title: String? = nil,
        id: String? = nil,
        footer: String? = nil,
        cells: @escaping () -> [Plan.Cell]
    ) {
        self.title = title
        self.id = id
        self.footer = footer
        self.cells = cells()
        self.isExpanded = nil
        self.emptyPlaceholder = nil
    }
    
}

// MARK: - Functions

public extension Plan.Section {
    
    var rowPlaceholderString: String? {
        guard let emptyPlaceholder, cells.isEmpty
        else { return nil }
        return emptyPlaceholder
    }
    
}

// MARK: - Views

extension Plan.Section: View {
    public var body: some View {
        if let isExpanded {
            ExpandableSection(isExpanded: isExpanded) {
                cellsView
            } header: {
                headerView
            }
        } else {
            ExpandableSection {
                cellsView
            } header: {
                headerView
            }
        }
    }
    
    // TODO: Maybe add footer?
    
    @ViewBuilder
    var headerView: some View {
        title.map {
            Text($0)
                .textCase(.none)
        }
    }
    
    @ViewBuilder
    var cellsView: some View {
        rowPlaceholderString.map {
            Text($0)
                .foregroundStyle(.secondary)
        }
        ForEach(cells.compactMap { $0 }.identified) { cell in
            cell
                .tag(cell.id)
            // `.borderless` on the row allows any contained buttons to show in their button style.
                .buttonStyle(.borderless)
        }
    }
    
}

public extension Array where Element == Plan.Section {
    var body: some View {
        ForEach(self.identified) { $0 }
    }
}

// MARK: - Previews

struct PlanSection_Previews: PreviewProvider {
    
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        
        @State var isExpanded = false
        
        var body: some View {
            Plan.List(
                sections: [
                    Plan.Section(
                        id: "Expandable",
                        isExpanded: $isExpanded,
                        title: "Expandable",
                        cells: [
                            .detail("cell 1"),
                            .detail("cell 2"),
                        ]
                    ),
                    Plan.Section(
                        id: "not expandable",
                        title: "not expandable",
                        cells: [
                            .detail("cell 1"),
                            .detail("cell 2"),
                        ]
                    ),
                ]
            )
        }
    }
}
