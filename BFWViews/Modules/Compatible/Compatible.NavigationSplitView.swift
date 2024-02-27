//
//  Compatible.NavigationSplitView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 27/2/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Compatible {
    
    public struct NavigationSplitView<
        Sidebar: View,
        Content: View,
        Detail: View
    > {
        let sidebar: () -> Sidebar
        let content: () -> Content
        let detail: () -> Detail
        
        let externalColumnVisibility: Binding<NavigationSplitViewVisibility>?
        @State var internalColumnVisibility: NavigationSplitViewVisibility = .automatic
        
        let externalPreferredCompactColumn: Binding<NavigationSplitViewColumn>?
        @State var internalPreferredCompactColumn: NavigationSplitViewColumn = .sidebar
        
        public init(
            columnVisibility: Binding<NavigationSplitViewVisibility>? = nil,
            preferredCompactColumn: Binding<NavigationSplitViewColumn>? = nil,
            sidebar: @escaping () -> Sidebar,
            content: @escaping () -> Content,
            detail: @escaping () -> Detail
        ) {
            self.externalColumnVisibility = columnVisibility
            self.externalPreferredCompactColumn = preferredCompactColumn
            self.sidebar = sidebar
            self.content = content
            self.detail = detail
        }
        
        var columnVisibility: Binding<NavigationSplitViewVisibility> {
            externalColumnVisibility ?? $internalColumnVisibility
        }
        
        var preferredCompactColumn: Binding<NavigationSplitViewColumn> {
            externalPreferredCompactColumn ?? $internalPreferredCompactColumn
        }
        
    }
    
    public enum NavigationSplitViewVisibility {
        case automatic
        case all
        case detailOnly
        case doubleColumn
        
        var displayMode: UISplitViewController.DisplayMode {
            switch self {
            case .automatic: .automatic
            case .all: .twoBesideSecondary
            case .detailOnly: .secondaryOnly
            case .doubleColumn: .oneBesideSecondary
            }
        }
        
    }
    
    public enum NavigationSplitViewColumn {
        case sidebar
        case content
        case detail
    }
}

@available(iOS 16.0, *)
public extension NavigationSplitViewVisibility {
    
    init(_ visibility: Compatible.NavigationSplitViewVisibility) {
        self = switch visibility {
        case .automatic: .automatic
        case .all: .all
        case .detailOnly: .detailOnly
        case .doubleColumn: .doubleColumn
        }
    }
    
    var compatible: Compatible.NavigationSplitViewVisibility {
        switch self {
        case .automatic: .automatic
        case .all: .all
        case .detailOnly: .detailOnly
        case .doubleColumn: .doubleColumn
        default: .automatic
        }
    }
    
}

@available(iOS 17.0, *)
public extension NavigationSplitViewColumn {
    
    init(_ column: Compatible.NavigationSplitViewColumn) {
        self = switch column {
        case .content: .content
        case .sidebar: .sidebar
        case .detail: .detail
        }
    }
    
    var compatible: Compatible.NavigationSplitViewColumn {
        switch self {
        case .content: .content
        case .sidebar: .sidebar
        case .detail: .detail
        default: .sidebar
        }
    }
}

@available(iOS 17.0, *)
extension Binding where Value == Compatible.NavigationSplitViewColumn {
    var newer: Binding<NavigationSplitViewColumn> {
        map { .init($0) } reverse: { $0.compatible }
    }
}

@available(iOS 16.0, *)
extension Binding where Value == Compatible.NavigationSplitViewVisibility {
    var newer: Binding<NavigationSplitViewVisibility> {
        map { .init($0) } reverse: {  $0.compatible }
    }
}

extension Compatible.NavigationSplitView: View {
    public var body: some View {
        if #available(iOS 17.0, *) {
            NavigationSplitView(
                columnVisibility: columnVisibility.newer,
                preferredCompactColumn: preferredCompactColumn.newer,
                sidebar: sidebar,
                content: content,
                detail: detail
            )
        } else if #available(iOS 16.0, *) {
            NavigationSplitView(
                columnVisibility: columnVisibility.newer,
                sidebar: sidebar,
                content: content,
                detail: detail
            )
        } else {
            NavigationView {
                sidebar()
                content()
                    .splitViewDisplayMode(columnVisibility.wrappedValue.displayMode)
              detail()
            }
        }
    }
}

private extension View {
    
    // TODO: Delete if not needed.
    func splitViewShowColumn(
        _ column: UISplitViewController.Column?
    ) -> some View {
        uiSplitViewController { splitViewController in
            guard let splitViewController,
                  let column
            else { return }
            DispatchQueue.main.async {
                splitViewController.show(column)
            }
        }
    }
    
    func splitViewDisplayMode(
        _ displayMode: UISplitViewController.DisplayMode
    ) -> some View {
        uiSplitViewController { splitViewController in
            guard let splitViewController else { return }
            DispatchQueue.main.async {
                splitViewController.preferredDisplayMode = displayMode
            }
        }
    }
    
}
