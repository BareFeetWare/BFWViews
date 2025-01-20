//
//  Plan.ConfirmationDialog.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 23/1/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

extension Plan {
    public struct ConfirmationDialog {
        public let title: String?
        public let message: String?
        public let buttons: [Plan.Button]
        
        public init(
            title: String?,
            message: String? = nil,
            buttons: [Plan.Button]
        ) {
            self.title = title
            self.message = message
            self.buttons = buttons
        }
        
        /*
        /// For backwards compatiblity
        public init(
            title: String?,
            buttonTitle: String,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.buttons = [
                Plan.Button(buttonTitle) { action() }
            ]
        }
        */
        
        var titleVisibility: Visibility {
            title != nil ? .visible : .hidden
        }
    }
}

// MARK: - Views

extension View {
    
    @ViewBuilder
    public func confirmationDialog(
        _ confirmationBinding: Binding<Plan.ConfirmationDialog?>
    ) -> some View {
        if let confirmation = confirmationBinding.wrappedValue {
            self.confirmationDialog(
                confirmation.title ?? "Confirm",
                isPresented: confirmationBinding.isNotNil,
                titleVisibility: confirmation.titleVisibility
            ) {
                ForEach(confirmation.buttons, id: \.title) { $0 }
            } message: {
                if let message = confirmation.message {
                    Text(message)
                }
            }
        } else {
            self
        }
    }
    
}

// MARK: - Previews

struct PlanConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Preview()
                .navigationTitle("Plan.Confirmation")
        }
    }
    
    struct Preview: View {
        @State var confirmation: Plan.ConfirmationDialog?
        @State var result: String = "None"
        
        var body: some View {
            List {
                HStack {
                    Text("Result:")
                    Spacer()
                    Text(result)
                }
                Button("Do First") {
                    confirmation = .init(
                        title: "Do First?",
                        buttons: [
                            .init("First") { self.result = "First" },
                        ]
                    )
                }
                Button("Do Second") {
                    confirmation = .init(
                        title: "Do Second?",
                        buttons: [
                            .init("Second") { self.result = "Second" },
                        ]
                    )
                }
            }
            .confirmationDialog($confirmation)
        }
    }
}
