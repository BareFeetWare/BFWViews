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
        let children = Mirror(reflecting: subject).children
        guard !children.isEmpty
        else { return nil }
        self.init(
            cells: children.map { .init(child: $0) }
        )
    }
}

public extension Plan.Cell {
    
    init(child: Mirror.Child) {
        if let array = child.value as? Array<Any> {
            self = .detail(
                child.label ?? "?",
                trailing: String(describing: array.count)
            ) {
                Plan.List(
                    cells: array.map { .init(reflecting: $0) }
                )
            }
        } else {
            self = .detail(
                child.label ?? "?",
                trailing: String.unwrappedDescription(any: child.value)
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
    static func unwrappedDescription(any: Any) -> Self {
        // TODO: Ignore compiler warning.
        let anyOptional = any as! Optional<Any>
        switch anyOptional {
        case .none: return "nil"
        case .some(let value):
            return String(describing: value)
        }
    }
}
