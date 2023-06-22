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

public extension Array where Element == Plan.Cell {
    /// Adjusts the layout of an array of cells to keep titles horizontally aligned, by adding Image.space in cells that have no image, if at least one cell has an image.
    func alignedTitles() -> Self {
        guard let maxWidth = compactMap(
            {
                ($0.content() as? Plan.DetailRow)?.image?.width
            }
        )
            .max()
        else { return self }
        return map { cell in
            guard let detailRow = (cell.content() as? Plan.DetailRow),
                  detailRow.image == nil
            else { return cell }
            return .init(id: cell.id) {
                Plan.DetailRow(
                    id: detailRow.id,
                    title: detailRow.title,
                    subtitle: detailRow.subtitle,
                    image: {
                        guard let image = detailRow.image
                        else { return .space(width: maxWidth) }
                        return .init(
                            source: image.source,
                            width: maxWidth,
                            color: image.color,
                            cornerRadius: image.cornerRadius
                        )
                    }(),
                    trailingContent: detailRow.trailingContent
                )
            }
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
