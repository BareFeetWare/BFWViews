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
    public protocol RowConstructor: View {
        associatedtype Scene: View
        static func button(_ content: Plan.Button) -> Self
        static func detail(_ content: Plan.DetailRow) -> Self
        static func navigationLink(_ content: Plan.NavigationLink<Self, Scene>) -> Self
        static func optionalIdentified(_ optionalIdentified: OptionalIdentified<AnyView>) -> Self
    }
}

extension Plan {
    /// Simple concrete implementation of Plan.RowConstructor. Copy this to your app and add your own instances.
    public indirect enum Row: Plan.RowConstructor {
        public typealias Scene = Plan.Scene
        case button(Plan.Button)
        case detail(Plan.DetailRow)
        case navigationLink(Plan.NavigationLink<Self, Scene>)
        case optionalIdentified(OptionalIdentified<AnyView>)
    }
}

// TODO: Move

extension Plan.Row: View {
    public var body: some View {
        switch self {
        case let .button(content): content
        case let .detail(content): content
        case let .navigationLink(content): content
        case let .optionalIdentified(content): content
        }
    }
}

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
    
    static func anyView<Content: View>(id: String? = nil, content: () -> Content) -> Self {
        .optionalIdentified(.init(id: id, content: AnyView(content())))
    }
    
    static func navigationLink<Destination: View>(
        _ row: Self,
        title: String?,
        destination: Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: row,
                title: title,
                destination: destination
            )
        )
    }
    
    static func navigationLink<Destination: View>(
        _ row: Self,
        title: String?,
        destination: @escaping () async throws -> Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: row,
                title: title,
                destination: destination
            )
        )
    }
    
    // Instances that embed DetailRow in another Row:
    
    static func detail<Destination: View> (
        _ detailRow: Plan.DetailRow,
        destination: @escaping () async throws -> Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: .detail(detailRow),
                title: detailRow.title,
                destination: destination
            )
        )
    }
    
    static func detail<Destination: View> (
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: .detail(
                    title,
                    id: id,
                    subtitle: subtitle,
                    trailing: trailing,
                    image: image
                ),
                title: title,
                destination: destination
            )
        )
    }
    
}

public extension Plan.RowConstructor
where Scene: Plan.SceneConstructor,
      Scene.Row == Self
{
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        list: Plan.List<Self, Scene>
    ) -> Self {
        .navigationLink(
            .detail(detailRow),
            title: detailRow.title,
            destination: .list(list)
        )
    }
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        list: @escaping () async throws -> Plan.List<Self, Scene>
    ) -> Self {
        .navigationLink(
            .detail(detailRow),
            title: detailRow.title
        ) {
            .list(try await list())
        }
    }
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        rows: [Self]
    ) -> Self {
        .navigationLink(
            .detail(detailRow),
            title: detailRow.title
        ) {
            .list(Plan.List(rows: rows))
        }
    }
    
    static func detail(
        _ detailRow: Plan.DetailRow,
        rows: @escaping () async throws -> [Self]
    ) -> Self {
        .navigationLink(
            .detail(detailRow),
            title: detailRow.title
        ) {
            .list(Plan.List(rows: try await rows()))
        }
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        list: @escaping () async throws -> Plan.List<Self, Scene>
    ) -> Self {
        .navigationLink(
            .detail(.init(id: id, title: title, subtitle: subtitle, trailing: trailing)),
            title: title
        ) {
            .list(try await list())
        }
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        rows: @escaping () async throws -> [Self]
    ) -> Self {
        .navigationLink(
            .detail(.init(id: id, title: title, subtitle: subtitle, trailing: trailing)),
            title: title
        ) {
            .list(Plan.List(rows: try await rows()))
        }
    }
}
