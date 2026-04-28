//
//  Plan.Button.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

extension Plan {
    public struct Button {
        public let title: String
        public let systemImage: String?
        public let role: ButtonRole?
        private let dispatch: Dispatch
        @State var isInProgress: Bool = false
        @State var alert: Plan.Alert?
        
        public init(
            _ title: String,
            systemImage: String? = nil,
            role: ButtonRole? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.systemImage = systemImage
            self.role = role
            self.dispatch = .sync(action)
        }

        public init(
            _ title: String,
            systemImage: String? = nil,
            role: ButtonRole? = nil,
            action: @escaping () async throws -> Void
        ) {
            self.title = title
            self.systemImage = systemImage
            self.role = role
            self.dispatch = .async(action)
        }
    }
}

// MARK: - Types

extension Plan.Button {
    
    // TODO: Consolidate with root level Dispatch.
    
    private enum Dispatch {
        case sync(() -> Void)
        case async(() async throws -> Void)
    }
    
}

// MARK: - Functions

extension Plan.Button {
    
    var action: () -> Void {
        switch dispatch {
        case .sync(let action):
            return { action() }
        case .async(let action):
            return {
                withErrorAlert($alert) {
                    isInProgress = true
                    defer { isInProgress = false }
                    try await action()
                }
            }
        }
    }
}

// MARK: - Views

extension Plan.Button: View {
    public var body: some View {
        Group {
            if let systemImage {
                Button(title, systemImage: systemImage, role: role, action: action)
            } else {
                Button(title, role: role, action: action)
            }
        }
        .disabled(isInProgress)
        .overlay {
            if isInProgress {
                ProgressView()
            }
        }
        .alert($alert)
    }
}

// MARK: - Previews

struct Plan_Button_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Plan.Button("Button Sync") {}
            Plan.Button("Button Async") {
                try await Task.sleep(nanoseconds: 2 * 1000_000_000)
            }
            Plan.Button("Button Async Error") {
                try await Task.sleep(nanoseconds: 2 * 1000_000_000)
                throw NSError(domain: "Test", code: 0, userInfo: nil)
            }
        }
    }
}
