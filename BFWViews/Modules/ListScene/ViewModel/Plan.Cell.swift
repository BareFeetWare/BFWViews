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
                            foregroundColor: image.foregroundColor,
                            backgroundColor: image.backgroundColor,
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
    
    static func button(
        _ title: String,
        action: @escaping () -> Void
    ) -> Self {
        .init(id: "button: \(title)") {
            Button(title) {
                action()
            }
        }
    }
    
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
    
    static func navigationLink<Destination: View>(
        detailRow: Plan.DetailRow,
        // TODO: Avoid needing overrides
        overridingNavigationTitle: String? = nil,
        overridingNavigationSubtitle: String? = nil,
        selection: Binding<String?>? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        let navigationTitle = overridingNavigationTitle
        ?? (
            detailRow.title.map { title in
                title.hasSuffix(":")
                ? String(title.dropLast())
                : title
            }
        )
        let navigationSubtitle = overridingNavigationSubtitle ?? detailRow.subtitle
        let titledDestination = {
            try await destination()
                .navigationHeader(
                    title: navigationTitle,
                    subtitle: navigationSubtitle
                )
        }
        let content = AsyncNavigationLink(
            tag: detailRow.id,
            selection: selection,
            destination: titledDestination,
            label: { detailRow }
        )
        return .init(id: detailRow.id, content: { content })
    }
    
    static func detail<Destination: View>(
        _ title: String,
        id explicitID: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil,
        // TODO: Avoid needing overrides
        overridingNavigationTitle: String? = nil,
        overridingNavigationSubtitle: String? = nil,
        selection: Binding<String?>? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        let appliedID = explicitID ?? "title: " + title
        let detailRow = Plan.DetailRow(
            id: appliedID,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            image: image
        )
        return .navigationLink(
            detailRow: detailRow,
            overridingNavigationTitle: overridingNavigationTitle,
            overridingNavigationSubtitle: overridingNavigationSubtitle,
            selection: selection,
            destination: destination
        )
    }
    
    // TODO: Consolidate above and below functions.
    
    static func detail<Destination: View>(
        _ title: String,
        id explicitID: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil,
        // TODO: Avoid needing overrides
        overridingNavigationTitle: String? = nil,
        overridingNavigationSubtitle: String? = nil,
        selection: Binding<String?>? = nil,
        destination: () -> Destination
    ) -> Self {
        let appliedID = explicitID ?? "title: " + title
        let navigationTitle = overridingNavigationTitle
        ?? (
            title.hasSuffix(":")
            ? String(title.dropLast())
            : title
        )
        let navigationSubtitle = overridingNavigationSubtitle ?? subtitle
        let label = Plan.DetailRow(
            id: appliedID,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            image: image
        )
        let titledDestination = {
            destination()
                .navigationHeader(
                    title: navigationTitle,
                    subtitle: navigationSubtitle
                )
        }
        let content = if let selection {
            NavigationLink(
                tag: appliedID,
                selection: selection,
                destination: titledDestination,
                label: { label }
            )
        } else {
            NavigationLink(
                destination: titledDestination,
                label: { label }
            )
        }
        return .init(id: appliedID, content: { content })
    }
    
}

private extension View {
    
    // TODO: Refactor the above functions to use this shared code.
    
    func parsedNavigationHeader(
        title: String,
        subtitle: String?,
        // TODO: Avoid needing overrides
        overridingNavigationTitle: String? = nil,
        overridingNavigationSubtitle: String? = nil
    ) -> some View {
        let navigationTitle = overridingNavigationTitle
        ?? (
            title.hasSuffix(":")
            ? String(title.dropLast())
            : title
        )
        let navigationSubtitle = overridingNavigationSubtitle ?? subtitle
        return navigationHeader(
            title: navigationTitle,
            subtitle: navigationSubtitle
        )
    }
}

struct PlanCell_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State var selectedCellID: String?
        
        var body: some View {
            NavigationView {
                Plan.List(
                    selection: $selectedCellID,
                    cells: [
                        Plan.Cell(id: "1") {
                            NavigationLink(
                                tag: "1",
                                selection: $selectedCellID
                            ) {
                                Text("Destination 1")
                            } label: {
                                Text("Cell 1")
                            }
                        },
                        Plan.Cell(id: "2") {
                            NavigationLink(
                                tag: "2",
                                selection: $selectedCellID
                            ) {
                                Text("Destination 2")
                            } label: {
                                Text("Cell 2")
                            }
                        },
                        .detail("Cell 3", id: "3", selection: $selectedCellID) {
                            Text("selection = \(selectedCellID ?? "nil")")
                        },
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
