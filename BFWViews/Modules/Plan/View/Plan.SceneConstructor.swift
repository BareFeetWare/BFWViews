//
//  Plan.SceneConstructor.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    protocol SceneConstructor: View {
        associatedtype Row: View
        typealias Scene = Self
        typealias Section = Plan.Section<Row, Scene>
        typealias List = Plan.List<Row, Scene>
        
        static func list(_ list: List) -> Self
        static func optionalIdentified(_ optionalIdentified: OptionalIdentified<AnyView>) -> Self
    }
}

// MARK: - Static Instances

public extension Plan.SceneConstructor {
    
    static func list(
        sections: [Section]
    ) -> Self {
        .list(.init(sections: sections))
    }
    
    static func list(
        rows: [Row]
    ) -> Self {
        .list(.init(rows: rows))
    }
    
    static func list(
        rows: () async throws -> [Row]
    ) async throws -> Self {
        .list(
            .init(
                rows: try await rows()
            )
        )
    }
    
    static func view<V: View>(
        id: String? = nil,
        _ view: V
    ) -> Self {
        .optionalIdentified(
            OptionalIdentified(view: view)
        )
    }
    
    /// Avoid using case view, since it erases type. Instead add your own cases.
    static func view<V: View>(
        id: String? = nil,
        _ view: () async throws -> V
    ) async throws -> Self {
        .view(try await view())
    }
    
}
