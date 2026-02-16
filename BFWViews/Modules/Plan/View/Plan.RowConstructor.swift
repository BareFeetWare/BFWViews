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
        static func picker(_ content: Plan.Picker) -> Self
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
    
    static func navigationLink<Destination: View>(
        _ title: String,
        destination: @escaping () async throws -> Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: .detail(title),
                title: title,
                destination: destination
            )
        )
    }
    
    static func picker(
        _ title: String,
        selection: Binding<String>,
        options: [String]
    ) -> Self {
        .picker(
            .init(
                title,
                selection: selection,
                options: options
            )
        )
    }

    static func picker<Item: RawRepresentable>(
        _ title: String,
        selection: Binding<Item>,
        options: [Item]
    ) -> Self where Item.RawValue == String {
        .picker(
            .init(
                title,
                selection: selection
                    .map { $0.rawValue } reverse: { .init(rawValue: $0)! },
                options: options.map { $0.rawValue }
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
