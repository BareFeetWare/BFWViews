//
//  Plan+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/5/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan.Cell where Row: Plan.RowConstructor {
    
    private static func mirror(
        _ detailRow: Plan.DetailRow,
        reflecting subject: Any?
    ) -> Self {
        if let subject,
           let cells = cells(reflecting: subject)
        {
            .mirror(detailRow) { cells }
        } else {
            .detail(detailRow)
        }
    }
    
    public static func cells(reflecting subject: Any?) -> [Self]? {
        guard let subject,
              let children = Mirror(reflecting: subject).children.nilIfEmpty
        else { return nil }
        return children.map { child in
            let childMirror = Mirror(reflecting: child.value)
            let childValue: Any? = childMirror.displayStyle == .optional
            ? childMirror.children.first?.value
            : child.value
            let summary = childValue.map {
                String(String(describing: $0).prefix(50))
            } ?? "nil"
            return .mirror(
                .init(
                    child.label ?? summary,
                    trailing: child.label == nil ? nil : summary
                ),
                reflecting: childValue
            )
        }
    }
    
}

public extension Plan.List where Row: Plan.RowConstructor {
    
    init?(reflecting subject: Any?) {
        guard let cells = Cell.cells(reflecting: subject)
        else { return nil }
        self.init(cells: cells)
    }
    
}

public extension Plan.SceneConstructor where Row: Plan.RowConstructor {
    
    static func reflecting(
        _ subject: Any?
    ) -> Self {
        .list(
            cells: Cell.cells(reflecting: subject) ?? []
        )
    }
    
    static func reflecting(
        _ subject: () async throws -> Any?
    ) async throws -> Self {
        .list(
            cells: Cell.cells(reflecting: try await subject()) ?? []
        )
    }
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
