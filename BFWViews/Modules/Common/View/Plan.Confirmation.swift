//
//  Plan.Confirmation.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 23/1/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Confirmation {
        public let title: String?
        public let buttonTitle: String
        public let action: () -> Void
        
        public init(
            title: String?,
            buttonTitle: String,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.buttonTitle = buttonTitle
            self.action = action
        }
    }
}

extension View {
    
    @ViewBuilder
    public func confirmationDialog(
        _ confirmationBinding: Binding<Plan.Confirmation?>
    ) -> some View {
        if let confirmation = confirmationBinding.wrappedValue {
            self.confirmationDialog(
                confirmation.title ?? "Confirm",
                isPresented: confirmationBinding.isNotNil,
                titleVisibility: confirmation.title != nil ? .visible : .hidden
            ) {
                Button(confirmation.buttonTitle, role: .none) {
                    confirmation.action()
                }
                Button("Cancel", role: .cancel) {}
            }
        } else {
            self
        }
    }
    
}

struct PlanConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Preview()
                .navigationTitle("Plan.Confirmation")
        }
    }
    
    struct Preview: View {
        @State var confirmation: Plan.Confirmation?
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
                        buttonTitle: "First"
                    ) {
                        self.result = "First"
                    }
                }
                Button("Do Second") {
                    confirmation = .init(
                        title: "Do Second?",
                        buttonTitle: "Second"
                    ) {
                        self.result = "Second"
                    }
                }
            }
            .confirmationDialog($confirmation)
        }
    }
}
