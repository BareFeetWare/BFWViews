//
//  Plan.Node.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/8/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    struct Node<Row> {
        public let row: Row
        public let sectionsDispatch: Dispatch<[Section]>?
    }
}

// MARK: - Types

public extension Plan.Node {
    
    struct Section: OptionalIdentifiable {
        public let id: String?
        public let title: String?
        public let nodes: [Plan.Node<Row>]
    }
    
    enum Dispatch<T> {
        case sync(T)
        case async(() async throws -> T)
    }
    
}

// MARK: - Convenience Inits

public extension Plan.Node {
    
    init(_ row: Row, sections: [Section]?) {
        self.row = row
        self.sectionsDispatch = sections.map { .sync($0) }
    }
    
    init(_ row: Row, sections: @escaping () async throws -> [Section]) {
        self.row = row
        self.sectionsDispatch = .async(sections)
    }
    
    init(_ row: Row, nodes: [Self]? = nil) {
        self.row = row
        self.sectionsDispatch = nodes.map { .sync([Section(nodes: $0)]) }
    }
    
    init(_ row: Row, nodes: @escaping () async throws -> [Self]) {
        self.row = row
        self.sectionsDispatch = .async {
            try await [Section(nodes: nodes())]
        }
    }
}

public extension Plan.Node.Section {
    
    init(_ title: String? = nil, id: String? = nil, nodes: [Plan.Node<Row>]) {
        self.title = title
        self.id = id
        self.nodes = nodes
    }
    
    init(_ title: String? = nil, id: String? = nil, nodes: () -> [Plan.Node<Row>]) {
        self.title = title
        self.id = id
        self.nodes = nodes()
    }
}

extension Plan.Node: OptionalIdentifiable where Row: OptionalIdentifiable {
    public var id: String? { row.id }
}

// MARK: - Views

extension Plan.Node: View where Row: View & Titled & OptionalIdentifiable {
    public var body: some View {
        switch sectionsDispatch {
        case .none:
            row
        case .sync(let sections):
            NavigationLink {
                List {
                    ForEach(sections.identified()) { $0 }
                }
                .navigationTitle(row.title)
            } label: {
                row
            }
        case .async(let sections):
            AsyncNavigationLink(tag: row.id) {
                let sections = try await sections()
                return List {
                    ForEach(sections.identified()) { $0 }
                }
                .navigationTitle(row.title)
            } label: {
                row
            }
        }
    }
}

extension Plan.Node.Section: View where Plan.Node<Row>: OptionalIdentifiable & View {
    public var body: some View {
        SwiftUI.Section {
            ForEach(nodes.identified()) { $0 }
        } header: {
            title.map { Text($0) }
        }
    }
}
