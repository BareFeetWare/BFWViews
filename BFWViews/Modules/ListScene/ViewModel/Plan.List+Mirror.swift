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
        let cells: [Plan.Cell] = .init(reflecting: subject)
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
        } else {
            self = .detail(
                child.label ?? "?",
                trailing: String(unwrapping: child.value)
            )
        }
    }
    
    init(reflecting subject: Any) {
        let detailRow = (subject as? (any DetailRowRepresentable))?.detailRow
        ?? .init(
            title: String(String(describing: subject).prefix(200))
        )
        if let list = Plan.List(reflecting: subject) {
            self = .navigationLink(detailRow: detailRow) {
                list
            }
        } else {
            self = .init { detailRow }
        }
    }
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
}
