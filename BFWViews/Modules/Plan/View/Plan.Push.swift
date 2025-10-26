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
        public let row: DetailRow
        public let destination: Dispatch<Scene>
    }
}

// MARK: - Convenience Inits

public extension Plan.Push {
    
    init(row: Plan.DetailRow, destination: Scene) {
        self.row = row
        self.destination = .sync(destination)
    }
    
    init(_ row: Plan.DetailRow, destination: @escaping () async throws -> Scene) {
        self.row = row
        self.destination = .async(destination)
    }
    
}

// MARK: - Views

extension Plan.Push: View {
    public var body: some View {
        switch destination {
        case .async(let scene):
            AsyncNavigationLink(tag: row.id) {
                try await scene()
                    .navigationTitle(row.title)
            } label: {
                row
            }
        case .sync(let scene):
            NavigationLink {
                scene
                    .navigationTitle(row.title)
            } label: {
                row
            }
        }
    }
}
