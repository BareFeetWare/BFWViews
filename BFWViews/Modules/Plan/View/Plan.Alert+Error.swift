//
//  Plan.Alert+Error.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 6/4/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

// Source: BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension Plan.Alert {
    
    init(error: Error, buttons: [Plan.Button] = []) {
        self.init(
            title: error.alertTitle,
            message: error.alertMessage,
            buttons: buttons
        )
    }
    
}

private extension Binding where Value == Optional<Error> {
    
    var alertBinding: Binding<Plan.Alert?> {
        .init {
            wrappedValue.map { .init(error: $0) }
        } set: {
            if $0 == nil {
                wrappedValue = nil
            }
        }
    }
}

// MARK: - Views

public extension View {
    func alert(error errorBinding: Binding<Error?>) -> some View {
        alert(errorBinding.alertBinding)
    }
}

// MARK: - With Error Alert

public func withErrorAlert(
    _ alert: Binding<Plan.Alert?>,
    _ action: @escaping () async throws -> Void
) {
    Task {
        do {
            try await action()
        } catch {
            alert.wrappedValue = .init(error: error)
        }
    }
}

// MARK: - Previews

struct Plan_Alert_Error_Previews: PreviewProvider {
    
    struct Preview: View {
        @State private var error: Error?
        
        enum BasicError: Error {
            case noConnection
        }
        
        enum EntryError: LocalizedError {
            case invalidEmail
            
            public var errorDescription: String? {
                switch self {
                case .invalidEmail: "Invalid email"
                }
            }
            
            var recoverySuggestion: String? {
                switch self {
                case .invalidEmail: "Try another email"
                }
            }
        }
        
        var body: some View {
            List {
                Button("Show alert with LocalizedError") {
                    error = EntryError.invalidEmail
                }
                Button("Show alert with basic Error") {
                    error = BasicError.noConnection
                }
            }
            .alert(error: $error)
            .navigationTitle("Alert error")
        }
    }
    
    static var previews: some View {
        NavigationView {
            Preview()
        }
    }
}
