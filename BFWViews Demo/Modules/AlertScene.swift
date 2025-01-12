//
//  AlertScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 4/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct AlertScene {
    @State private var presentedError: Error?
    @State private var presentedAlert: Plan.Alert?
    
    enum SomeError: LocalizedError {
        case test
        
        var errorDescription: String? {
            switch self {
            case .test: "Problem description"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .test: "recoverySuggestion"
            }
        }
    }
}

// MARK: - Functions

extension AlertScene {
        
    var buttons: [Plan.Button] {
        [
            .init("Show Error Alert") {
                presentedError = SomeError.test
            },
            .init("Show Custom Alert") {
                presentedAlert = Plan.Alert(
                    title: "Title",
                    message: "Message",
                    buttons: [
                        .init("Button") {}
                    ]
                )
            },
        ]
    }
    
}

// MARK: - Views

extension AlertScene: View {
    var body: some View {
        Form {
            ForEach(buttons, id: \.title) { $0 }
        }
        .alert(error: $presentedError)
        .alert($presentedAlert)
    }
}

// MARK: - Previews

struct AlertScene_Previews: PreviewProvider {
    static var previews: some View {
        AlertScene()
    }
}
