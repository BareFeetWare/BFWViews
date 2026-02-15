//
//  Plan.Scene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    
    /// A simple concrete implementation of Plan.SceneConstructor, for apps that don't require their own scenes.
    enum Scene: Plan.SceneConstructor {
        case list(Plan.List<Row, Scene>)
        case optionalIdentified(OptionalIdentified<AnyView>)
    }
}

// MARK: - Views

extension Plan.Scene: View {
    public var body: some View {
        switch self {
        case let .list(content): content
        case let .optionalIdentified(content): content
        }
    }
}
