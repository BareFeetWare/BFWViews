//
//  Plan.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public enum Cell<Scene: View> {
        case button(Plan.Button)
        case detail(Plan.DetailRow)
        case push(Plan.Push<Scene>)
        /// Avoid using case view, since it erases type.
        case optionalIdentified(OptionalIdentified<AnyView>)
    }
}

// MARK: - Protocol Implementations

extension Plan.Cell: OptionalIdentifiable {
    public var id: String? {
        switch self {
        case .button:
            nil
        case .detail(let row):
            row.id.map { "row(id: \($0))" }
        case .push(let push):
            push.row.id.map { "row(id: \($0))" }
        case .optionalIdentified(let identified):
            identified.id.map { "view(id: \($0)" }
        }
    }
}

// MARK: - Views

extension Plan.Cell: View {
    public var body: some View {
        switch self {
        case .button(let button): button
        case .detail(let detailRow): detailRow
        case .push(let push): push
        case .optionalIdentified(let identified): identified
        }
    }
}

// MARK: - Previews

struct PlanCell_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State var selectedCellID: String?
        
        var body: some View {
            NavigationView {
                Plan.Simple.List(
                    selection: $selectedCellID,
                    cells: [
                        .button("Button 1") {},
                        .detail("Detail 1"),
                        .push("Push 1") {
                            [
                                .detail("Destination 1"),
                            ]
                        },
                        .view {
                            NavigationLink(
                                tag: "2",
                                selection: $selectedCellID
                            ) {
                                Text("Destination 2")
                            } label: {
                                Text("Cell 2")
                            }
                        },
                        // TODO: Reimplement selection
                        /*
                        Plan.Cell.detail("Cell 3", id: "3", selection: $selectedCellID) {
                            Text("selection = \(selectedCellID ?? "nil")")
                        },
                         */
                    ]
                )
                .navigationTitle("Plan.Cell")
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
