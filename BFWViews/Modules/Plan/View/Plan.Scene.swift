//
//  Plan.Scene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    enum Scene<Cell: View> {
        case list(Plan.List<Cell>)
        // Avoid using case view, since it erases type. Instead add your own cases.
        // TODO: Enable:
        //case view(Identified<AnyView>)
    }
}

// MARK: - Protocol Implementation

public extension Plan {
    protocol SceneConstructor {
        associatedtype Cell: View
        static func list(_ list: Plan.List<Cell>) -> Self
        //static func view(_ identified: Identified<AnyView>) -> Self
    }
}

// Conforming Plan.Scene so it can be used in a simple app that doesn't need to add its own Scene instances.

extension Plan.Scene: Plan.SceneConstructor {}

public extension Plan.SceneConstructor {
    
    static func list(isSearchable: Bool = false, sections: [Plan.Section<Cell>]) -> Self {
        .list(.init(isSearchable: isSearchable, sections: sections))
    }
    
    static func list(isSearchable: Bool = false, cells: [Cell]) -> Self {
        .list(.init(isSearchable: isSearchable, cells: cells))
    }
    
}

// MARK: - Static Instances

public extension Plan.Scene {
    
    static func list(
        isSearchable: Bool = false,
        sections: [Plan.Section<Cell>]
    ) -> Self {
        .list(.init(isSearchable: isSearchable, sections: sections))
    }
    
    static func list(
        isSearchable: Bool = false,
        cells: [Cell]
    ) -> Self {
        .list(.init(isSearchable: isSearchable, cells: cells))
    }
    
    // TODO: Enable:
    /*
    static func view<Content: View>(_ content: Content) -> Self {
        .view(AnyView(content))
    }
    
    static func view<Content: View>(_ content: () async throws -> Content) async throws -> Self {
        .view(AnyView(try await content()))
    }
     */
}

// MARK: - Views

extension Plan.Scene: View {
    public var body: some View {
        switch self {
        case let .list(content): content
        //case let .view(content): content
        }
    }
}
