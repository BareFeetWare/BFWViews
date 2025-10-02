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

public extension RandomAccessCollection where Element: OptionalIdentifiable {
    var identified: [Identified<Element>] {
        enumerated().map { index, element in
                .init(
                    id: element.id ?? "index: \(index)",
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

public extension ForEach where ID == String {
    init<C: RandomAccessCollection>(
        _ collection: C,
        @ViewBuilder content: @escaping (C.Element) -> Content
    ) where C.Element: OptionalIdentifiable,
    Data == [Identified<C.Element>],
    Content: View
    {
        self.init(
            collection.identified,
            id: \Identified<C.Element>.id
        ) { item in
            content(item.content)
        }
    }
}
