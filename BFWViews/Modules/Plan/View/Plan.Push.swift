//
//  Plan.Push.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    
    enum Dispatch<T> {
        case sync(T)
        case async(() async throws -> T)
    }
    
    struct Push {
        let row: DetailRow
        let destination: Dispatch<Scene>
        
        public init(row: DetailRow, destination: Scene) {
            self.row = row
            self.destination = .sync(destination)
        }
        
        init(_ row: DetailRow, destination: @escaping () async throws -> Scene) {
            self.row = row
            self.destination = .async(destination)
        }
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
