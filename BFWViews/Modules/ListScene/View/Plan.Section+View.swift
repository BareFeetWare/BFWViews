//
//  Plan.Section+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/7/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

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
    
    @ViewBuilder
    var headerView: some View {
        if let header = header {
            AnyView(header())
        }
    }
    
    @ViewBuilder
    var cellsView: some View {
        rowPlaceholderString.map {
            Text($0)
                .foregroundStyle(.secondary)
        }
        ForEach(cells.compactMap { $0 }) { cell in
            cell
                .tag(cell.id)
            // `.borderless` on the row allows any contained buttons to show in their button style.
                .buttonStyle(.borderless)
        }
    }
    
}

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
                        isExpanded: $isExpanded,
                        header: {
                            Text("expandable")
                        },
                        cells: [
                            .detail("cell 1"),
                            .detail("cell 2"),
                        ]
                    ),
                    Plan.Section(
                        header: {
                            Text("not expandable")
                        },
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
