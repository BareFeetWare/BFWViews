//
//  Error+Alert.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 12/3/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import Foundation

public extension Error {

    /// A short title suitable for alert or error display.
    var alertTitle: String {
        if self is DecodingError {
            "Decoding Error"
        } else if let error = self as? LocalizedError {
            error.failureReason ?? error.localizedDescription
        } else {
            "Error: \(self)"
        }
    }

    /// An optional message providing additional detail for alert or error display.
    var alertMessage: String? {
        if let error = self as? DecodingError {
            error.alertDebugDescription
        } else if let error = self as? LocalizedError {
            error.recoverySuggestion
        } else {
            nil
        }
    }

    /// `alertTitle` and `alertMessage` joined into one string, for logging or compact display.
    var alertDescription: String {
        [alertTitle, alertMessage]
            .compactMap { $0 }
            .joined(separator: " ")
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
    var alertDebugDescription: String? {
        guard let context else { return nil }
        let codingPath = context.codingPath.map { $0.stringValue }
        let labeledCodingPath = "codingPath: " + codingPath.joined(separator: ".")
        return [labeledCodingPath, context.debugDescription]
            .joined(separator: "\n")
    }
}
