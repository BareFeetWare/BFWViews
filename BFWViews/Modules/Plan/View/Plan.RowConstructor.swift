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
        static func anyView(_ content: AnyView) -> Self
        static func button(_ content: Plan.Button) -> Self
        static func detail(_ content: Plan.DetailRow) -> Self
        static func labeledContent(_ content: Plan.LabeledContent<Self, Self>) -> Self
        static func navigationLink(_ content: Plan.NavigationLink<Self, Scene>) -> Self
        static func optionalIdentified(_ optionalIdentified: OptionalIdentified<Self>) -> Self
        static func picker(_ content: Plan.Picker) -> Self
        static func textField(_ content: Plan.TextField) -> Self
        static func timelineView(_ content: Plan.TimelineView<Self>) -> Self
        static func toggle(_ content: Plan.Toggle) -> Self
    }
}

// MARK: - Static instances

public extension Plan.RowConstructor {
    
    static func anyView<Content: View>(_ content: () -> Content) -> Self {
        .anyView(AnyView(content()))
    }
    
    static func button(_ title: String, action: @escaping () async throws -> Void) -> Self {
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
    
    static func labeledContent(
        _ title: String,
        subtitle: String? = nil,
        content: Self
    ) -> Self {
        .labeledContent(
            .init(label: .detail(title, subtitle: subtitle), content: content)
        )
    }
    
    static func optionalIdentified(id: String?, row: Self) -> Self {
        .optionalIdentified(.init(id: id, content: row))
    }
    
    static func navigationLink<Destination: View>(
        _ row: Self,
        title: String? = nil,
        style: Plan.NavigationLink<Self, Scene>.Style = .push,
        isActive: Binding<Bool>? = nil,
        destination: Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: row,
                title: title,
                style: style,
                isActive: isActive,
                destination: destination
            )
        )
    }
    
    static func navigationLink<Destination: View>(
        _ row: Self,
        title: String? = nil,
        style: Plan.NavigationLink<Self, Scene>.Style = .push,
        isActive: Binding<Bool>? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: row,
                title: title,
                style: style,
                isActive: isActive,
                destination: destination
            )
        )
    }
    
    static func navigationLink<Destination: View>(
        _ title: String,
        style: Plan.NavigationLink<Self, Scene>.Style = .push,
        isActive: Binding<Bool>? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self where Scene == Destination {
        .navigationLink(
            Plan.NavigationLink(
                label: .detail(title),
                title: title,
                style: style,
                isActive: isActive,
                destination: destination
            )
        )
    }
    
    static func picker(
        _ title: String,
        selection: Binding<String>,
        options: [String],
        style: Plan.Picker.Style = .automatic
    ) -> Self {
        .picker(
            .init(
                title,
                selection: selection,
                options: options,
                style: style
            )
        )
    }

    static func picker<Item: RawRepresentable>(
        _ title: String,
        selection: Binding<Item>,
        options: [Item],
        style: Plan.Picker.Style = .automatic
    ) -> Self where Item.RawValue == String {
        .picker(
            .init(
                title,
                selection: selection
                    .map { $0.rawValue } reverse: { .init(rawValue: $0)! },
                options: options.map { $0.rawValue },
                style: style
            )
        )
    }
    
    static func textField(
        _ detailRow: Plan.DetailRow,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) -> Self {
        .textField(
            .init(
                detailRow,
                text: text,
                isSecure: isSecure,
                keyboardType: keyboardType,
                textContentType: textContentType
            )
        )
    }
    
    static func secureField(
        _ title: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) -> Self {
        .textField(
            .init(
                title,
                text: text,
                isSecure: true,
                keyboardType: keyboardType,
                textContentType: textContentType
            )
        )
    }
    
    static func textField(
        _ title: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) -> Self {
        .textField(
            .init(
                title,
                text: text,
                isSecure: isSecure,
                keyboardType: keyboardType,
                textContentType: textContentType
            )
        )
    }
    
    static func timelineView(
        timeInterval: TimeInterval,
        content: @escaping () -> Self
    ) -> Self {
        .timelineView(
            .init(timeInterval: timeInterval, content: content)
        )
    }
    
    static func toggle(
        _ detailRow: Plan.DetailRow,
        isOn: Binding<Bool>
    ) -> Self {
        .toggle(
            .init(
                detailRow: detailRow,
                isOn: isOn
            )
        )
    }
    
    static func toggle(
        _ title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) -> Self {
        .toggle(
            .init(
                detailRow: .init(title, subtitle: subtitle),
                isOn: isOn
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
