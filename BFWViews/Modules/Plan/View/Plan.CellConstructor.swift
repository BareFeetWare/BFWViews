//
//  Plan.CellConstructor.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    protocol CellConstructor {
        associatedtype Scene: View
        static func button(_ button: Plan.Button) -> Self
        static func detail(_ row: Plan.DetailRow) -> Self
        static func push(_ push: Plan.Push<Scene>) -> Self
        static func optionalIdentified(_ optionalIdentified: OptionalIdentified<AnyView>) -> Self
    }
}

// Conforming Plan.Cell so it can be used in a simple app that doesn't need to add its own Cell instances.
extension Plan.Cell: Plan.CellConstructor {}

// MARK: - Static instances

public extension Plan.CellConstructor {
    
    static func button(_ title: String, action: @escaping () -> Void) -> Self {
        .button(.init(title, action: action))
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil
    ) -> Self {
        .detail(
            .init(
                title,
                id: id,
                subtitle: subtitle,
                trailing: trailing,
                image: image
            )
        )
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
        .optionalIdentified(OptionalIdentified(id: id, content: AnyView(content)))
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
