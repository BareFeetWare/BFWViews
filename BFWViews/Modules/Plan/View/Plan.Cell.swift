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
        case view(OptionalIdentified<AnyView>)
    }
}

// MARK: - Protocol Implementations

public extension Plan {
    protocol CellConstructor {
        associatedtype Scene: View
        static func button(_ button: Plan.Button) -> Self
        static func detail(_ row: Plan.DetailRow) -> Self
        static func push(_ push: Plan.Push<Scene>) -> Self
        static func view(_ view: OptionalIdentified<AnyView>) -> Self
    }
}

extension Plan.Cell: OptionalIdentifiable {
    public var id: String? {
        switch self {
        case .button:
            nil
        case .detail(let row):
            row.id.map { "row(id: \($0))" }
        case .push(let push):
            push.row.id.map { "row(id: \($0))" }
        case .view(let identified):
            identified.id.map { "view(id: \($0)" }
        }
    }
}

// Conforming Plan.Cell so it can be used in a simple app that doesn't need to add its own Cell instances.
extension Plan.Cell: Plan.CellConstructor {}

// MARK: - Static instances

public extension Plan.CellConstructor {
    
    static func button(_ title: String, action: @escaping () -> Void) -> Self {
        .button(.init(title, action: action))
    }
    
    static func detail(_ title: String, id: String? = nil, subtitle: String? = nil, trailing: String? = nil) -> Self {
        .detail(.init(title, id: id, subtitle: subtitle, trailing: trailing))
    }
    
    static func push(_ row: Plan.DetailRow, destination: Scene) -> Self {
        .push(.init(row: row, destination: .sync(destination)))
    }
    
    static func push(_ row: Plan.DetailRow, destination: @escaping () async throws -> Scene) -> Self {
        .push(.init(row: row, destination: .async(destination)))
    }
    
    static func push(_ title: String, id: String? = nil, subtitle: String? = nil, trailing: String? = nil, destination: Scene) -> Self {
        .push(.init(id: id, title: title, subtitle: subtitle, trailing: trailing), destination: destination)
    }
    
    static func push(_ title: String, id: String? = nil, subtitle: String? = nil, trailing: String? = nil, destination: @escaping () async throws -> Scene) -> Self {
        .push(.init(.init(id: id, title: title, subtitle: subtitle, trailing: trailing), destination: destination))
    }
    
    static func view<Content: View>(id: String? = nil, content: Content) -> Self {
        .view(OptionalIdentified(id: id, content: AnyView(content)))
    }
    
    static func view<Content: View>(id: String? = nil, content: () -> Content) -> Self {
        .view(id: id, content: content())
    }
}

public extension Plan.CellConstructor
where Scene: Plan.SceneConstructor, Scene.Cell == Self
{
    
    static func push(
        _ row: Plan.DetailRow,
        cells: [Self]
    ) -> Self {
        .push(.init(row: row, destination: .list(.init(cells: cells))))
    }
    
    static func push(
        _ row: Plan.DetailRow,
        cells: @escaping () async throws -> [Self]
    ) -> Self {
        .push(row) { .list(.init(cells: try await cells())) }
    }
    
    static func push(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        cells: @escaping () async throws -> [Self]
    ) -> Self {
        .push(title, id: id, subtitle: subtitle, trailing: trailing) { .list(cells: try await cells()) }
    }
    
    static func push<Destination: View>(
        _ row: Plan.DetailRow,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        .push(row) {
            try await Scene.view(destination)
        }
    }
    
    static func push<Destination: View>(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        .push(
            Plan.DetailRow(
                id: id,
                title: title,
                subtitle: subtitle,
                trailing: trailing
            )
        ) {
            try await Scene.view(destination)
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
        case .view(let identified): identified
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
