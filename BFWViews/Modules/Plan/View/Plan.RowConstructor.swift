//
//  Plan.RowConstructor.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    /// Provides Plan.Row instances
    public protocol RowConstructor {
        static func button(_ content: Plan.Button) -> Self
        static func detail(_ content: Plan.DetailRow) -> Self
        static func optionalIdentified(_ optionalIdentified: OptionalIdentified<AnyView>) -> Self
    }
}

extension Plan {
    /// Simple concrete implementation of Plan.RowConstructor. Copy this to your app and add your own instances.
    public enum Row: Plan.RowConstructor {
        case button(Plan.Button)
        case detail(Plan.DetailRow)
        case optionalIdentified(OptionalIdentified<AnyView>)
    }
}

// TODO: Move

extension Plan.Row: View {
    public var body: some View {
        switch self {
        case let .button(content): content
        case let .detail(content): content
        case let .optionalIdentified(content): content
        }
    }
}

/// Provides Plan.RowContructor instances, usually via enum Row.
extension Plan.Cell where Row: Plan.RowConstructor {}

// MARK: - Static instances

public extension Plan.RowConstructor {
    
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
    
    static func view<Content: View>(id: String? = nil, content: Content) -> Self {
        .optionalIdentified(.init(id: id, content: AnyView(content)))
    }
}

public extension Plan.Cell where Row: Plan.RowConstructor {
    
    static func button(_ title: String, action: @escaping () -> Void) -> Self {
        .init(.button(.init(title, action: action)))
    }
    
    static func detail(_ detailRow: Plan.DetailRow) -> Self {
        .init(.detail(detailRow))
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil
    ) -> Self {
        .init(
            .detail(
                .init(
                    title,
                    id: id,
                    subtitle: subtitle,
                    trailing: trailing,
                    image: image
                )
            )
        )
    }
    
    static func detail(_ detailRow: Plan.DetailRow, destination: Scene) -> Self {
        .init(
            .detail(detailRow),
            branch: .push(.init(detailRow.title, destination: destination))
        )
    }
    
    static func detail(_ detailRow: Plan.DetailRow, destination: @escaping () async throws -> Scene) -> Self {
        .init(
            .detail(detailRow),
            branch: .push(.init(detailRow.title, destination: destination))
        )
    }
    
    static func detail(_ title: String, id: String? = nil, subtitle: String? = nil, trailing: String? = nil, destination: Scene) -> Self {
        .init(
            .detail(.init(id: id, title: title, subtitle: subtitle, trailing: trailing)),
            branch: .push(.init(title, destination: destination))
        )
    }
    
    static func detail(_ title: String, id: String? = nil, subtitle: String? = nil, trailing: String? = nil, destination: @escaping () async throws -> Scene) -> Self {
        .init(
            .detail(.init(id: id, title: title, subtitle: subtitle, trailing: trailing)),
            branch: .push(.init(title, destination: destination))
        )
    }
    
    static func view<Content: View>(id: String? = nil, content: Content) -> Self {
        .init(
            .optionalIdentified(OptionalIdentified(id: id, content: AnyView(content))),
            branch: nil
        )
    }
    
    static func view<Content: View>(id: String? = nil, content: () -> Content) -> Self {
        .view(id: id, content: content())
    }
}

public extension Plan.Cell
where Row: Plan.RowConstructor,
      Scene: Plan.SceneConstructor,
      Scene.Row == Row
{
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        list: Plan.List<Row, Scene>
    ) -> Self {
        .init(
            .detail(detailRow),
            branch: .push(
                .init(
                    detailRow.title,
                    destination: .list(list)
                )
            )
        )
    }
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        list: @escaping () async throws -> Plan.List<Row, Scene>
    ) -> Self {
        .init(
            .detail(detailRow),
            branch: .push(
                .init(detailRow.title) {
                    .list(try await list())
                }
            )
        )
    }
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        cells: [Self]
    ) -> Self {
        .init(
            .detail(detailRow),
            branch: .push(
                .init(detailRow.title) {
                    .list(Plan.List(cells: cells))
                }
            )
        )
    }
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        cells: @escaping () async throws -> [Self]
    ) -> Self {
        .init(
            .detail(detailRow),
            branch: .push(
                .init(detailRow.title) {
                    .list(Plan.List(cells: try await cells()))
                }
            )
        )
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        list: @escaping () async throws -> Plan.List<Row, Scene>
    ) -> Self {
        .init(
            .detail(.init(id: id, title: title, subtitle: subtitle, trailing: trailing)),
            branch: .push(
                .init(title) {
                    .list(try await list())
                }
            )
        )
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        cells: @escaping () async throws -> [Self]
    ) -> Self {
        .init(
            .detail(.init(id: id, title: title, subtitle: subtitle, trailing: trailing)),
            branch: .push(
                .init(title) {
                    .list(Plan.List(cells: try await cells()))
                }
            )
        )
    }
}
