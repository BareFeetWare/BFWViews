//
//  Plan.Link.swift
//  BFWViews
//
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Link {
        public let title: String
        public let systemImage: String?
        public let destination: URL
        
        public init(
            _ title: String,
            systemImage: String? = nil,
            destination: URL
        ) {
            self.title = title
            self.systemImage = systemImage
            self.destination = destination
        }
    }
}

// MARK: - Views

extension Plan.Link: View {
    public var body: some View {
        if let systemImage {
            SwiftUI.Link(destination: destination) {
                Label(title, systemImage: systemImage)
            }
        } else {
            SwiftUI.Link(title, destination: destination)
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        Plan.Link("Plain", destination: URL(string: "https://example.com")!)
        Plan.Link("With icon", systemImage: "safari", destination: URL(string: "https://example.com")!)
    }
}
