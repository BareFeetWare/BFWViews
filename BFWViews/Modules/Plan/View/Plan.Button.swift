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
        public let confirmation: Confirmation?
        private let dispatch: Dispatch?
        @State var isInProgress: Bool = false
        @State var alert: Plan.Alert?
        @State var confirmationDialog: Plan.ConfirmationDialog?
        
        public init(
            _ title: String,
            systemImage: String? = nil,
            role: ButtonRole? = nil,
            confirmation: Confirmation? = nil,
            action: (() -> Void)?
        ) {
            self.title = title
            self.systemImage = systemImage
            self.role = role
            self.confirmation = confirmation
            self.dispatch = action.map { .sync($0) }
        }
        
        public init(
            _ title: String,
            systemImage: String? = nil,
            role: ButtonRole? = nil,
            confirmation: Confirmation? = nil,
            action: (() async throws -> Void)?
        ) {
            self.title = title
            self.systemImage = systemImage
            self.role = role
            self.confirmation = confirmation
            self.dispatch = action.map { .async($0) }
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
    
    /// Metadata for a confirmation dialog that gates a button's action. When a `Plan.Button` is constructed with a non-nil `confirmation`, tap first presents a `Plan.ConfirmationDialog` built from these fields; the dialog's primary button then runs the button's original action. `buttonTitle: nil` falls back to the outer button's title.
    public struct Confirmation {
        public let title: String
        public let message: String?
        public let buttonTitle: String?
        public let buttonRole: ButtonRole?
        
        public init(
            title: String,
            message: String? = nil,
            buttonTitle: String? = nil,
            buttonRole: ButtonRole? = nil
        ) {
            self.title = title
            self.message = message
            self.buttonTitle = buttonTitle
            self.buttonRole = buttonRole
        }
    }
    
}

// MARK: - Functions

extension Plan.Button {
    
    var isDisabled: Bool {
        dispatch == nil || isInProgress
    }
    
    var action: () -> Void {
        if let confirmation, let underlyingAction {
            return {
                confirmationDialog = Plan.ConfirmationDialog(
                    title: confirmation.title,
                    message: confirmation.message,
                    buttons: [
                        Plan.Button(
                            confirmation.buttonTitle ?? title,
                            role: confirmation.buttonRole,
                            action: underlyingAction
                        ),
                    ]
                )
            }
        }
        switch dispatch {
        case .none:
            return {}
        case .sync(let action):
            return action
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

    /// The dispatched action reified as an async-throwing closure, suitable for handing to another `Plan.Button`. Returns nil when the button has no action (disabled).
    private var underlyingAction: (() async throws -> Void)? {
        switch dispatch {
        case .none: nil
        case .sync(let action): { action() }
        case .async(let action): action
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
        .disabled(isDisabled)
        .overlay {
            if isInProgress {
                ProgressView()
            }
        }
        .alert($alert)
        .confirmationDialog($confirmationDialog)
    }
}

// MARK: - Previews

struct Plan_Button_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Plan.Button("Button Sync") {}
            Plan.Button("Button Async") {
                try await Task.sleep(seconds: 2)
            }
            Plan.Button("Button Async Error") {
                try await Task.sleep(seconds: 2)
                throw NSError(domain: "Test", code: 0, userInfo: nil)
            }
            Plan.Button(
                "Save",
                confirmation: .init(
                    title: "Save changes?",
                    message: "This will overwrite the existing record."
                )
            ) {
                try await Task.sleep(seconds: 1)
            }
            Plan.Button(
                "Delete",
                role: .destructive,
                confirmation: .init(
                    title: "Delete this item?",
                    message: "This cannot be undone.",
                    buttonRole: .destructive
                )
            ) {
                try await Task.sleep(seconds: 1)
            }
            Plan.Button(
                "Replace",
                confirmation: .init(
                    title: "Replace the existing entry?",
                    buttonTitle: "Replace and continue"
                )
            ) {
                try await Task.sleep(seconds: 1)
            }
        }
    }
}
