//
//  Plan.Alert.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 6/4/21.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Source: BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension Plan {
    struct Alert {
        public let title: String
        public let message: String?
        /// The buttons to display. Use role: .cancel for a cancel button. Provide no buttons to show system default OK button.
        public let buttons: [Plan.Button]
        
        public init(
            title: String,
            message: String?,
            buttons: [Plan.Button] = []
        ) {
            self.title = title
            self.message = message
            self.buttons = buttons
        }
    }
}

// MARK: - Views

public extension View {
    @ViewBuilder
    func alert(_ alertBinding: Binding<Plan.Alert?>) -> some View {
        if let alert = alertBinding.wrappedValue {
            self.alert(
                alert.title,
                isPresented: alertBinding.isNotNil
            ) {
                ForEach(alert.buttons, id: \.title) { $0 }
            } message: {
                alert.message.map { Text($0) }
            }
        } else {
            self
        }
    }
}

// MARK: - Previews

#Preview("OK") {
    Text("Content")
        .alert(
            .constant(
                .init(
                    title: "Title",
                    message: "Message"
                    // No buttons, shows system OK.
                )
            )
        )
}

#Preview("Do and Cancel") {
    Text("Content")
        .alert(
            .constant(
                .init(
                    title: "Title",
                    message: "Do action?",
                    buttons: [
                        .init("Cancel", role: .cancel) {},
                        .init("Do") {
                            // Do action.
                        },
                    ]
                )
            )
        )
}
