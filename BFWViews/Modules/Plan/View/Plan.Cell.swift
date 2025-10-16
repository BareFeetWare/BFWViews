//
//  Plan.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public enum Cell {
        case button(Plan.Button)
        case detail(Plan.DetailRow)
        case push(Push)
        // TODO: Remove AnyView.
        case view(OptionalIdentified<AnyView>)
    }
}

public extension Plan.Cell {
    struct IdentifiableView: OptionalIdentifiable {
        public let id: String?
        public let anyView: AnyView
    }
}

// MARK: - Protocol Implementations

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

// MARK: - Static instances
// Add your own custom instances in your project.

public extension Plan.Cell {
    
    init<Content: View>(id: String?, content: () -> Content) {
        self = .view(.init(id: id, content: AnyView(content())))
    }
    
    static func view<Content: View>(
        _ content: Content
    ) -> Self {
        .view(.init(id: nil, content: AnyView(content)))
    }
    
    static func view<Content: View>(
        _ content: () -> Content
    ) -> Self {
        .view(.init(id: nil, content: AnyView(content())))
    }
    
    static func view<Content: View>(
        _ content: Content
    ) -> Self where Content: Identifiable {
        .view(
            .init(
                id: String(describing: content.id),
                content: AnyView(content)
            )
        )
    }
    
    static func button(
        _ title: String,
        action: @escaping () -> Void
    ) -> Self {
        .button(.init(title, action: action))
    }
    
    static func push(
        _ row: Plan.DetailRow,
        destination: @escaping () async throws -> Plan.Scene
    ) -> Self {
        .push(
            .init(row, destination: destination)
        )
    }
    
    static func push(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        destination: @escaping () async throws -> Plan.Scene
    ) -> Self {
        .push(.init(title: title, subtitle: subtitle, trailing: trailing)) {
            try await destination()
        }
    }
    
    static func push(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        cells: @escaping () async throws -> [Plan.Cell]
    ) -> Self {
        .push(.init(title: title, subtitle: subtitle, trailing: trailing)) {
            .list(.init(cells: try await cells()))
        }
    }
    
    static func push<Destination: View>(
        _ row: Plan.DetailRow,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        .push(row) {
            .anyView(AnyView(try await destination()))
        }
    }

    static func push<Destination: View>(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        .push(.init(title: title, subtitle: subtitle, trailing: trailing)) {
            .anyView(AnyView(try await destination()))
        }
    }
    
    static func detail(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil
    ) -> Self {
        .detail(.init(title: title, subtitle: subtitle, trailing: trailing))
    }
    
    static func detail(
        _ title: String,
        id: String? = nil,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil
    ) -> Self {
        .detail(
            Plan.DetailRow(
                id: id,
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                image: image
            )
        )
    }
    
    // TODO: Perhaps consolidate above and below functions.
    /*
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
            detailRow.title.hasSuffix(":")
            ? String(detailRow.title.dropLast())
            : detailRow.title
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
            // TODO: Better handling of id.
            tag: detailRow.id ?? String(describing: detailRow),
            selection: selection,
            destination: titledDestination,
            label: { detailRow }
        )
        //return .init(id: detailRow.id, content: { content })
        return push(Plan.Push(row: detailRow, destination: titledDestination))
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
        destination: () -> Destination?
    ) -> Self {
        let appliedID = explicitID ?? "title: " + title
        let label = Plan.DetailRow(
            id: appliedID,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            image: image
        )
        if let destination = destination() {
            let navigationTitle = overridingNavigationTitle
            ?? (
                title.hasSuffix(":")
                ? String(title.dropLast())
                : title
            )
            let navigationSubtitle = overridingNavigationSubtitle ?? subtitle
            let titledDestination = {
                destination
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
        } else {
            return .init(id: appliedID, content: { label })
        }
    }
    */
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

// MARK: - Views

extension Plan.Cell: View {
    public var body: some View {
        switch self {
        case .view(let identified): identified.content
        case .button(let button): button
        case .detail(let detailRow): detailRow
        case .push(let push): push
        }
    }
}

// MARK: - Previews

struct PlanCell_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State var selectedCellID: String?
        
        var body: some View {
            NavigationView {
                Plan.List(
                    selection: $selectedCellID,
                    cells: [
                        .view {
                            NavigationLink(
                                tag: "1",
                                selection: $selectedCellID
                            ) {
                                Text("Destination 1")
                            } label: {
                                Text("Cell 1")
                            }
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
