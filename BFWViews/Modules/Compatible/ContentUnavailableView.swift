//
//  ContentUnavailableView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 28/1/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Backward compatibility implementation of ContentUnavailableView (iOS 17+).
public struct ContentUnavailableView {
    let title: String
    let systemImage: String
    let description: Text

    public init(_ title: String, systemImage: String, description: Text) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }
}

// MARK: - Views

extension ContentUnavailableView: View {

    public var body: some View {
        if #available(iOS 17.0, *) {
            SwiftUI.ContentUnavailableView(title, systemImage: systemImage, description: description)
        } else {
            VStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                description
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Previews

#Preview {
    ContentUnavailableView(
        "Could not load",
        systemImage: "exclamationmark.triangle",
        description: Text("Something went wrong.")
    )
}
