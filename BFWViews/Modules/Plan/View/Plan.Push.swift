//
//  Plan.Push.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Push<Scene: View> {
        // TODO: Richer title, perhaps using Plan.DetailRow.
        public let title: String?
        public let isActive: Binding<Bool>?
        public let destination: Dispatch<Scene>
    }
}

// MARK: - Convenience Inits

public extension Plan.Push {
    
    init(_ title: String?, isActive: Binding<Bool>? = nil, destination: Scene) {
        self.title = title
        self.isActive = isActive
        self.destination = .sync(destination)
    }
    
    init(_ title: String?, isActive: Binding<Bool>? = nil, destination: @escaping () async throws -> Scene) {
        self.title = title
        self.isActive = isActive
        self.destination = .async(destination)
    }
    
}
