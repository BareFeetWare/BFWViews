//
//  Plan.Simple.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 21/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    /// A concrete, non-generic implementation that uses the built-in Plan cells and scene.
    public enum Simple {
        public typealias List = Plan.List<Cell>
        public typealias Cell = Plan.Cell<Scene>
        
        public enum Scene: Plan.SceneConstructor {
            public typealias Cell = Plan.Simple.Cell
            case list(Plan.List<Cell>)
        }
    }
}

extension Plan.Simple.Scene: View {
    public var body: some View {
        switch self {
        case .list(let list): list
        }
    }
}
