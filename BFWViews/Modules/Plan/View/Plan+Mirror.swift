//
//  Plan+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/5/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan.RowConstructor {
    
    private static func mirror(
        _ detailRow: Plan.DetailRow,
        reflecting subject: Any?
    ) -> Self {
        if let subject,
           let rows = rows(reflecting: subject)
        {
            .mirror(detailRow) { rows }
        } else {
            .detail(detailRow)
        }
    }
    
    public static func rows(reflecting subject: Any?) -> [Self]? {
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
        guard let rows = Row.rows(reflecting: subject)
        else { return nil }
        self.init(rows: rows)
    }
    
}

public extension Plan.SceneConstructor where Row: Plan.RowConstructor {
    
    static func reflecting(
        _ subject: Any?
    ) -> Self {
        .list(
            rows: Row.rows(reflecting: subject) ?? []
        )
    }
    
    static func reflecting(
        _ subject: () async throws -> Any?
    ) async throws -> Self {
        .list(
            rows: Row.rows(reflecting: try await subject()) ?? []
        )
    }
}
