//
//  Plan.List+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/5/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import Foundation

public extension Plan.List where Selection == String {
    init?(reflecting subject: Any) {
        let cells: [Plan.Cell] = if let elements = subject as? Array<Any> {
            elements.map { element in
                (element as? CellRepresentable)?.cell
                ?? .init(reflecting: element)
            }
        } else {
            .init(reflecting: subject)
        }
        guard !cells.isEmpty
        else { return nil }
        self.init(cells: cells)
    }
}

public extension Array where Element == Plan.Cell {
    init(reflecting subject: Any) {
        self = Mirror(reflecting: subject).children
            .map { .init(child: $0) }
    }
}

public extension Plan.Cell {
    
    init(
        title: String,
        subjects: Array<Any>
    ) {
        self = .detail(title, trailing: "\(subjects.count)") {
            Plan.List(
                cells: subjects.map { subject in
                        .init(reflecting: subject)
                }
            )
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
            self = .detail(
                label,
                trailing: optionalValue
                    .map { String(describing: $0).truncated(50) }
                ?? "nil"
            ) {
                optionalValue.flatMap { Plan.List(reflecting: $0) }
            }
        } else {
            self = .navigationLink(
                detailRow: .init(any: child.value)
            ) {
                Plan.List(reflecting: child.value)
            }
        }
    }
    
    // TODO: Simplify
    
    init(title: String? = nil, reflecting subject: Any) {
        if let cell = (subject as? CellRepresentable)?.cell {
            self = cell
        } else {
            let detailRow: Plan.DetailRow = .init(title: title, any: subject)
            if let list = Plan.List(reflecting: subject) {
                self = .navigationLink(detailRow: detailRow) {
                    list
                }
            } else {
                self = .init { detailRow }
            }
        }
    }
}

private extension Plan.DetailRow {
    init(title: String? = nil, any: Any) {
        self = title.map { .init(title: $0) }
        ?? (any as? (any DetailRowRepresentable))?.detailRow
        ?? .init(
            title: String(describing: any).truncated(200)
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
    
    func truncated(_ length: Int) -> String {
        count < length
        ? String(prefix(length)) + "…"
        : self
    }
}

import SwiftUI

struct Plan_List_Mirror_Previews: PreviewProvider {
    
    static let list = Plan.List(cells: [cell])
    static let cell = Plan.Cell.detail("title", trailing: "trailing")
    static let detailRow = Plan.DetailRow(title: "title", trailing: "trailing")
    
    static var previews: some View {
        NavigationView {
            Plan.List(
                cells: [
                    .init(title: "List", reflecting: list),
                    .init(title: "Cell", reflecting: cell),
                    .init(title: "DetailRow", reflecting: detailRow),
                ]
            )
            .navigationTitle("Plan.List+Mirror")
        }
    }
}
