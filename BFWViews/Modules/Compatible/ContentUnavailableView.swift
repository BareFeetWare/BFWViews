//
//  ContentUnavailableView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 28/1/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Backward compatibility implementation of ContentUnavailableView (iOS 17+).
public struct ContentUnavailableView<Actions: View> {
    let title: String
    let systemImage: String
    let description: Text
    let actions: () -> Actions
    
    public init(
        _ title: String,
        systemImage: String,
        description: Text,
        @ViewBuilder actions: @escaping () -> Actions
    ) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
        self.actions = actions
    }
}

// MARK: - Inits

public extension ContentUnavailableView where Actions == EmptyView {
    
    init(_ title: String, systemImage: String, description: Text) {
        self.init(title, systemImage: systemImage, description: description) {
            EmptyView()
        }
    }
}

public extension ContentUnavailableView {
    
    /// Creates an error display with a warning icon, using the error's `alertTitle` and `alertMessage`.
    init(
        error: Error,
        @ViewBuilder actions: @escaping () -> Actions
    ) {
        self.init(
            error.alertTitle,
            systemImage: "exclamationmark.triangle",
            description: Text(error.alertMessage ?? ""),
            actions: actions
        )
    }
}

public extension ContentUnavailableView where Actions == EmptyView {
    
    /// Creates an error display with a warning icon and no actions.
    init(error: Error) {
        self.init(
            error.alertTitle,
            systemImage: "exclamationmark.triangle",
            description: Text(error.alertMessage ?? "")
        )
    }
}

// MARK: - View

extension ContentUnavailableView: View {

    public var body: some View {
        if #available(iOS 17.0, *) {
            SwiftUI.ContentUnavailableView {
                Label(title, systemImage: systemImage)
            } description: {
                description
            } actions: {
                actions()
            }
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
                actions()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Previews

#Preview("No actions") {
    ContentUnavailableView(
        "Could not load",
        systemImage: "exclamationmark.triangle",
        description: Text("Something went wrong.")
    )
}

#Preview("With actions") {
    ContentUnavailableView(
        "Could not load",
        systemImage: "exclamationmark.triangle",
        description: Text("Something went wrong.")
    ) {
        Button("Retry") {}
            .buttonStyle(.bordered)
    }
}

