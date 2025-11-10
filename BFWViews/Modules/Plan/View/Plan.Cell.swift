//
//  Plan.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Cell<Row: View, Scene: View> {
        public let row: Row
        public let branch: Branch?
        
        public init(_ row: Row, branch: Branch? = nil) {
            self.row = row
            self.branch = branch
        }
    }
}

public extension Plan.Cell {
    
    enum Branch {
        case disclosure(Disclosure)
        case push(Plan.Push<Scene>)
    }
    
    struct Disclosure {
        let isExpanded: Binding<Bool>?
        let cells: [Plan.Cell<Row, Scene>]
        
        public init(
            isExpanded: Binding<Bool>? = nil,
            cells: [Plan.Cell<Row, Scene>]
        ) {
            self.isExpanded = isExpanded
            self.cells = cells
        }
    }

}

// MARK: - Protocol Implementations

extension Plan.Cell: OptionalIdentifiable {
    public var id: String? {
        (row as? (any Identifiable)).map { String(describing: $0.id) }
        ?? (row as? OptionalIdentifiable)?.id
    }
}

// MARK: - Private Extensions

private extension DisclosureGroup {
    init(isExpanded: Binding<Bool>?, content: @escaping () -> Content, label: () -> Label) {
        if let isExpanded {
            self.init(isExpanded: isExpanded, content: content, label: label)
        } else {
            self.init(content: content, label: label)
        }
    }
}

// MARK: - Views

extension Plan.Cell: View {
    public var body: some View {
        switch branch {
        case .none:
            row
        case .disclosure(let disclosure):
            DisclosureGroup(isExpanded: disclosure.isExpanded) {
                disclosure
            } label: {
                row
            }
        case .push(let push):
            view(title: push.title, dispatch: push.destination)
        }
    }
    
    @ViewBuilder
    func view<Destination: View>(
        title: String?,
        dispatch: Dispatch<Destination>
    ) -> some View {
        switch dispatch {
        case .async(let scene):
            AsyncNavigationLink {
                try await scene()
                    .ifLet(title) { title, view in
                        view.navigationTitle(title)
                    }
            } label: {
                row
            }
        case .sync(let scene):
            NavigationLink {
                scene
                    .ifLet(title) { title, view in
                        view.navigationTitle(title)
                    }
            } label: {
                row
            }
        }
    }
    
}

extension Plan.Cell.Disclosure: View {
    public var body: some View {
        ForEach(cells.identified()) { $0.content }
    }
}

// MARK: - Previews

struct PlanCell_Previews: PreviewProvider {
    
    struct Preview: View {
        @State var selectedCellID: String?
        typealias List = Plan.List<Plan.Row, Plan.Scene>
        
        var body: some View {
            NavigationView {
                List(
                    selection: $selectedCellID,
                    cells: [
                        .button("Button 1") {},
                        .detail("Detail 1"),
                        .detail("Push 1") {
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
