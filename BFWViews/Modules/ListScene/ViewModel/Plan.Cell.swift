//
//  Plan.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Cell: Identifiable {
        public let id: String
        public let content: () -> any View
        
        public init<Content>(
            content: @escaping () -> Content
        ) where Content: View & Identifiable, Content.ID == String {
            self.id = content().id
            self.content = content
        }
        
        public init(
            id: String,
            content: @escaping () -> any View
        ) {
            self.id = id
            self.content = content
        }
    }
}

extension Plan.Cell: View {
    public var body: some View {
        AnyView(content())
    }
}

// MARK: - Static instances of Cell. Add your own custom instances in your project.

public extension Plan.Cell {
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil
    ) -> Self {
        .init {
            Plan.DetailRow(
                id: id,
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                image: image
            )
        }
    }
    
    // TODO: Perhaps consolidate above and below functions.
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil,
        destination: @escaping () async -> some View
    ) -> Self {
        let id = id ?? UUID().uuidString
        let navigationTitle = title.hasSuffix(":")
        ? String(title.dropLast())
        : title
        let label = Plan.DetailRow(
            id: id,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            image: image
        )
        let content = AsyncNavigationLink(
            destination: {
                await destination()
                    .navigationHeader(title: navigationTitle, subtitle: subtitle)
            },
            label: { label }
        )
        return .init(id: id, content: { content })
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil,
        destination: some View
    ) -> Self {
        let id = id ?? UUID().uuidString
        let navigationTitle = title.hasSuffix(":")
        ? String(title.dropLast())
        : title
        let label = Plan.DetailRow(
            id: id,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            image: image
        )
        let content = NavigationLink(
            destination: destination
                .navigationHeader(title: navigationTitle, subtitle: subtitle),
            label: { label }
        )
        return .init(id: id, content: { content })
    }
    
}
