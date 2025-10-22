//
//  Plan+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/5/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan.CellConstructor
where Scene: Plan.SceneConstructor, Scene.Cell == Self
{
    
    init(_ row: Plan.DetailRow, reflecting subject: Any?) {
        self = if let subject,
                  let cells: [Self] = .init(reflecting: subject)
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
            .init(title, subtitle: subtitle, trailing: trailing),
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
            Scene.reflecting(subject)
        }
    }
    
    // TODO: Enable
    /*
    static func push<Destination: View>(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        destination: @escaping () async throws -> Destination
    ) -> Self {
        .push(title, subtitle: subtitle, trailing: trailing) {
            Scene.view(try await destination())
        }
    }
    */
}

public extension Array
where Element: Plan.CellConstructor, Element.Scene: Plan.SceneConstructor, Element == Element.Scene.Cell
{
    
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
            return .init(
                .init(
                    child.label ?? summary,
                    trailing: child.label == nil ? nil : summary
                ),
                reflecting: childValue
            )
        }
    }
    
}

public extension Plan.SceneConstructor
where Cell: Plan.CellConstructor, Cell.Scene: Plan.SceneConstructor, Cell == Cell.Scene.Cell
{
    
    static func reflecting(_ subject: Any?) -> Self {
        .list(.init(reflecting: subject) ?? .init(cells: []))
    }
    
}

public extension Plan.List
where Cell: Plan.CellConstructor, Cell.Scene: Plan.SceneConstructor, Cell == Cell.Scene.Cell
{
    
    init?(reflecting subject: Any?) {
        guard let cells = [Cell](reflecting: subject)
        else { return nil }
        self.init(cells: cells)
    }
    
}

private extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
