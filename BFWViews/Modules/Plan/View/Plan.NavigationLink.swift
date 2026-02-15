//
//  Plan.NavigationLink.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct NavigationLink<Label: View, Destination: View> {
        public let label: Label
        public let title: String?
        public let isActive: Binding<Bool>?
        public let dispatch: Dispatch<Destination>
    }
}

// MARK: - Convenience Inits

public extension Plan.NavigationLink {
    
    init(
        label: Label,
        title: String?,
        isActive: Binding<Bool>? = nil,
        destination: Destination
    ) {
        self.label = label
        self.title = title
        self.isActive = isActive
        self.dispatch = .sync(destination)
    }
    
    init(label: Label, title: String?, isActive: Binding<Bool>? = nil, destination: @escaping () async throws -> Destination) {
        self.label = label
        self.title = title
        self.isActive = isActive
        self.dispatch = .async(destination)
    }
    
}

// MARK: - Views

extension Plan.NavigationLink: View {
    public var body: some View {
        switch dispatch {
        case .async(let destination):
            AsyncNavigationLink {
                try await destination()
                    .ifLet(title) { title, view in
                        view.navigationTitle(title)
                    }
            } label: {
                label
            }
        case .sync(let destination):
            NavigationLink {
                destination
                    .ifLet(title) { title, view in
                        view.navigationTitle(title)
                    }
            } label: {
                label
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        List {
            Plan.NavigationLink(
                label: Text("Label"),
                title: "Title",
                destination: Text("Destination")
            )
        }
    }
}
