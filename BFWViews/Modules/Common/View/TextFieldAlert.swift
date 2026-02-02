//
//  TextFieldAlert.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/2/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

/// One text field with internal state, Save and Cancel. Use with `.textFieldAlert($textFieldAlert)`.
public struct TextFieldAlert {
    public let title: String
    public let message: String?
    public let textFieldTitle: String
    public let onSave: (String) async throws -> Void
    
    public init(
        title: String,
        message: String?,
        textFieldTitle: String,
        onSave: @escaping (String) async throws -> Void
    ) {
        self.title = title
        self.message = message
        self.textFieldTitle = textFieldTitle
        self.onSave = onSave
    }
}

// MARK: - Types

extension TextFieldAlert {
    struct Modifier {
        @Binding var textFieldAlert: TextFieldAlert?
        /// The text state lives in the modifier because only View/ViewModifier can hold `@State`.
        @State private var text = ""
    }
}

// MARK: - Functions

extension TextFieldAlert.Modifier {
    
    var alertBinding: Binding<Plan.Alert?> {
        .init {
            guard let textFieldAlert else { return nil }
            return Plan.Alert(
                title: textFieldAlert.title,
                message: textFieldAlert.message,
                textFields: [.init(textFieldAlert.textFieldTitle, text: $text)],
                buttons: [
                    Plan.Button("Cancel", role: .cancel) {},
                    Plan.Button("Save") {
                        try await textFieldAlert.onSave(text)
                    },
                ]
            )
        } set: {
            if $0 == nil {
                textFieldAlert = nil
            }
        }
    }
}

// MARK: - Views

extension TextFieldAlert.Modifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .alert(alertBinding)
    }
}

// MARK: - View Extension

public extension View {
    @ViewBuilder
    func textFieldAlert(_ binding: Binding<TextFieldAlert?>) -> some View {
        if binding.wrappedValue != nil {
            modifier(TextFieldAlert.Modifier(textFieldAlert: binding))
        } else {
            self
        }
    }
}
