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

public struct OptionalIdentified<Content>: OptionalIdentifiable {
    public let id: String?
    public let content: Content
    
    public init(id: String?, content: Content) {
        self.id = id
        ?? (content as? (any Identifiable)).map { String(describing: $0.id) }
        ?? (content as? OptionalIdentifiable)?.id
        self.content = content
    }
}

// MARK: - Convenience Inits

extension OptionalIdentified {
    init (id: String? = nil, content: () -> Content) {
        self.init(id: id, content: content())
    }
}

// MARK: - Functions

public extension RandomAccessCollection {
    func identified() -> [Identified<Element>] {
        enumerated().map { index, element in
                .init(
                    id: (element as? (any Identifiable)).map { String(describing: $0) }
                    ?? (element as? OptionalIdentifiable)?.id
                    ?? "index: \(index)",
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

extension OptionalIdentified: View where Content: View {
    public var body: some View {
        content
    }
}

public extension ForEach where ID == String {
    init<C: RandomAccessCollection>(
        _ collection: C,
        @ViewBuilder content: @escaping (C.Element) -> Content
    ) where C.Element: OptionalIdentifiable,
    Data == [Identified<C.Element>],
    Content: View
    {
        self.init(
            collection.identified(),
            id: \Identified<C.Element>.id
        ) { item in
            content(item.content)
        }
    }
}
