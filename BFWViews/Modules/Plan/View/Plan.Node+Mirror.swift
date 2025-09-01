//
//  Plan.Node+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 28/8/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import Foundation

public extension Array where Element == Plan.Node<Plan.DetailRow> {
    
    init?(reflecting subject: Any) {
        guard let nodes = Mirror(reflecting: subject).children.nilIfEmpty
        else { return nil }
        self = nodes
            .map { .init(child: $0) }
    }
}

public extension Plan.Node<Plan.DetailRow> {
    
    init(
        title: String,
        subjects: Array<Any>
    ) {
        self.init(
            .init(
                title: title,
                trailing: "\(subjects.count)"
            )
        ) {
            subjects.map { subject in
                    .init(reflecting: subject)
            }
        }
    }
    
    init(child: Mirror.Child) {
        if let subjects = child.value as? Array<Any> {
            self.init(
                title: child.label ?? "?",
                subjects: subjects
            )
        } else if let label = child.label {
            let optionalValue: Any? = optional(child.value)
            self.init(
                .init(
                    title: label,
                    trailing: optionalValue
                        .map { String(describing: $0).truncated(length: 50) }
                    ?? "nil"
                ),
                nodes: optionalValue.flatMap {
                    .init(reflecting: $0)
                }
            )
        } else {
            let nodes = [Self](reflecting: child.value)
            self = .init(
                .init(any: child.value),
                nodes: nodes
            )
        }
    }
    
    // TODO: Simplify
    
    init(title: String? = nil, reflecting subject: Any) {
        let detailRow: Plan.DetailRow = .init(title: title, any: subject)
        let nodes = [Self](reflecting: subject)
        self = .init(
            detailRow,
            nodes: nodes
        )
    }
    
}

private extension Plan.DetailRow {
    init(title: String? = nil, any: Any) {
        self = title.map { .init(title: $0) }
        ?? (any as? (any DetailRowRepresentable))?.detailRow
        ?? .init(
            title: String(describing: any).truncated(length: 200)
        )
    }
}

/// Return an Optional, either the input value (if it is Optional), or wrapped in an Optional.
private func optional(_ value: Any) -> Any? {
    // TODO: Ignore compiler warning
    value as? Optional<Any> ?? value
}

private extension String {
    
    init(unwrapping subject: Any) {
        switch subject {
        case let .some(wrapped) as Any?:
            self.init(describing: wrapped)
        case .none as Any?:
            self.init("nil")
        default:
            self.init(describing: subject)
        }
    }
    
    func truncated(length: Int) -> String {
        count > length
        ? String(prefix(length)) + "…"
        : self
    }
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}

// MARK: - Views

import SwiftUI

// MARK: - Previews

struct Plan_Node_Mirror_Previews: PreviewProvider {
    
    static let node: Plan.Node<Plan.DetailRow> =
        .init(.init(title: "title", trailing: "trailing")) {
            [
                .init(.init(title: "Child 1")),
                .init(.init(title: "Child 2")),
            ]
        }
    
    static var previews: some View {
        NavigationView {
            List { node }
                .navigationTitle("Plan.DetailRow+Mirror")
        }
    }
}
