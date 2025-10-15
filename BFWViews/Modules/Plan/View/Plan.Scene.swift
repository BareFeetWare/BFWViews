//
//  Plan.Scene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    enum Scene {
        // TODO: Avoid AnyView
        case anyView(AnyView)
        case list(Plan.List)
    }
}

// MARK: - Static Instances

public extension Plan.Scene {
    
    static func list(
        isSearchable: Bool = false,
        sections: [Plan.Section]
    ) -> Self {
        .list(.init(isSearchable: isSearchable, sections: sections))
    }
    
    static func list(
        isSearchable: Bool = false,
        cells: [Plan.Cell]
    ) -> Self {
        .list(.init(isSearchable: isSearchable, cells: cells))
    }

    static func view<Content: View>(_ content: Content) -> Self {
        .anyView(AnyView(content))
    }
    
    static func view<Content: View>(_ content: () -> Content) -> Self {
        .anyView(AnyView(content()))
    }
}

// MARK: - Mirror

public extension Plan.Scene {
    
    static func reflecting(_ subject: Any?) -> Self {
        .list(.init(reflecting: subject) ?? .init(cells: []))
    }
    
}

// MARK: - Views

extension Plan.Scene: View {
    public var body: some View {
        switch self {
        case let .anyView(view): view
        case let .list(list): list
        }
    }
}
