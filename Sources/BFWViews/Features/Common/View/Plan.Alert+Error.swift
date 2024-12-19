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
    
    init(error: Error) {
        if let error = error as? DecodingError {
            self.init(
                title: "Decoding Error",
                message: error.debugDescription
            )
        } else if let error = error as? LocalizedError {
            self.init(
                title: error.failureReason ?? error.localizedDescription,
                message: error.recoverySuggestion
            )
        } else {
            self.init(
                title: "Error: \(error)",
                message: nil
            )
        }
    }
    
}

// MARK: - Private Extensions

private extension DecodingError {
    
    var context: Context? {
        switch self {
        case let .typeMismatch(_, context):
            context
        case let .valueNotFound(_, context):
            context
        case let .keyNotFound(_, context):
            context
        case let .dataCorrupted(context):
            context
        @unknown default:
            nil
        }
    }
    
    /// Parsed readable description of the decoding error.
    var debugDescription: String? {
        guard let context else { return nil }
        let codingPath = context.codingPath.map { $0.stringValue }
        let labeledCodingPath = "codingPath: " + codingPath.joined(separator: ".")
        return [labeledCodingPath, context.debugDescription]
            .joined(separator: "\n")
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
