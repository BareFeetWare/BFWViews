//
//  Plan.DisclosureGroup.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 10/9/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    /// A titled, collapsible group of rows, nested by placing a disclosure group among another's rows. Like `Plan.Section`, it carries its rows as data rather than a view builder, so a tree is described declaratively. `isExpanded` lets the caller drive expansion — seeding a pre-expanded tree, or forcing groups open while a search filters it; when nil the group manages its own expansion and starts collapsed.
    struct DisclosureGroup<Row: View>: OptionalIdentifiable {
        public let id: String?
        public let title: String
        public let isExpanded: Binding<Bool>?
        public let rows: [Row]
        
        public init(
            _ title: String,
            id: String? = nil,
            isExpanded: Binding<Bool>? = nil,
            rows: [Row]
        ) {
            self.id = id
            self.title = title
            self.isExpanded = isExpanded
            self.rows = rows
        }
    }
}

// MARK: - Views

extension Plan.DisclosureGroup: View {
    public var body: some View {
        if let isExpanded {
            SwiftUI.DisclosureGroup(isExpanded: isExpanded) {
                rowsView
            } label: {
                Text(title)
            }
        } else {
            SwiftUI.DisclosureGroup {
                rowsView
            } label: {
                Text(title)
            }
        }
    }
    
    var rowsView: some View {
        ForEach(rows) { $0 }
    }
}

// MARK: - Previews

struct PlanDisclosureGroup_Previews: PreviewProvider {
    
    struct Preview: View {
        @State var isExpanded = true
        
        var body: some View {
            List {
                Plan.DisclosureGroup(
                    "Operations",
                    id: "operations",
                    isExpanded: $isExpanded,
                    rows: [
                        Text("Office of COO"),
                        Text("Facilities"),
                    ]
                )
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
