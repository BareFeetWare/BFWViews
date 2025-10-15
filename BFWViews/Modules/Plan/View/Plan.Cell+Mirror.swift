//
//  Plan.Cell+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/5/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import Foundation

public extension Plan.Cell {
    
    init(_ row: Plan.DetailRow, reflecting subject: Any?) {
        self = if let subject,
                  let cells: [Plan.Cell] = .init(reflecting: subject)
        {
            .push(row) { .list(cells: cells) }
        } else {
            .detail(row)
        }
    }
    
    init(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        reflecting subject: Any?
    ) {
        self.init(
            .init(title: title, subtitle: subtitle, trailing: trailing),
            reflecting: subject
        )
    }
    
    static func push(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        reflecting subject: @escaping () async throws -> Any?
    ) -> Self {
        .push(title, subtitle: subtitle, trailing: trailing) {
            Plan.Scene.reflecting(subject)
        }
    }
    
}

public extension Array where Element == Plan.Cell {
    
    init?(reflecting subject: Any?) {
        guard let subject,
              let children = Mirror(reflecting: subject).children.nilIfEmpty
        else { return nil }
        self = children.map { child in
            let childMirror = Mirror(reflecting: child.value)
            let childValue: Any? = childMirror.displayStyle == .optional
            ? childMirror.children.first?.value
            : child.value
            let summary = childValue.map {
                String(String(describing: $0).prefix(50))
            } ?? "nil"
            return Plan.Cell(
                .init(
                    title: child.label ?? summary,
                    trailing: child.label == nil ? nil : summary
                ),
                reflecting: childValue
            )
        }
    }
    
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
