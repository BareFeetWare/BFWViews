//
//  Identified.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct Identified<Content>: Identifiable {
    public let id: String
    public let content: Content
}

/// Might provide an id.
public protocol OptionalIdentifiable {
    var id: String? { get }
}

public extension Array {
    
    var identified: [Identified<Element>] {
        enumerated().map { index, element in
                .init(
                    id: (element as? OptionalIdentifiable)?.id ?? "index: \(index)",
                    content: element
                )
        }
    }
    
}

// MARK: - Views

extension Identified: View where Content: View {
    public var body: some View {
        content
    }
}
