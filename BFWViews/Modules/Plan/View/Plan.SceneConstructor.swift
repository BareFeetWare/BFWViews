//
//  Plan.SceneConstructor.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    protocol SceneConstructor {
        associatedtype Cell: View
        static func list(_ list: Plan.List<Cell>) -> Self
        static func optionalIdentified(_ optionalIdentified: OptionalIdentified<AnyView>) -> Self
    }
}

// Conforming Plan.Scene so it can be used in a simple app that doesn't need to add its own Scene instances.
extension Plan.Scene: Plan.SceneConstructor {}

// MARK: - Static Instances

public extension Plan.SceneConstructor {
    
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
