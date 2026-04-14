//
//  Plan+Node.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/4/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import Foundation

// MARK: - Plan.Node row and scene building

public extension Plan.RowConstructor
where Scene: Plan.SceneConstructor,
      Scene.Row == Self
{
    
    static func defaultRow<Node: Plan.Node>(
        title: String? = nil,
        node: Node
    ) -> Plan.DetailRow {
        let valueTitle = node.title ?? node.summary
        return .init(
            title: title ?? valueTitle,
            subtitle: node.id.map { "id: \($0)" },
            trailing: title == nil ? node.singleValueString : valueTitle
        )
    }
    
    static func detail<Node: Plan.Node>(
        _ title: String? = nil,
        node: Node,
        detailRowForNode: ((Node) -> Plan.DetailRow?)? = nil
    ) -> Self {
        let detailRow = detailRowForNode?(node) ?? defaultRow(title: title, node: node)
        let rows = rows(
            node: node,
            detailRowForNode: detailRowForNode
        )
        return rows.isEmpty
        ? .detail(detailRow)
        : .detail(detailRow) { .list(rows: rows) }
    }
    
    static func detail<Node: Plan.Node>(
        _ detailRow: Plan.DetailRow,
        node: @escaping () async throws -> Node?,
        detailRowForNode: ((Node) -> Plan.DetailRow?)? = nil
    ) -> Self {
        .detail(detailRow) {
            try await .list(
                rows: {
                    let node = try await node()
                    let rows = rows(
                        node: node,
                        detailRowForNode: detailRowForNode
                    )
                    return rows.isEmpty
                    ? [.detail(.init(title: "nil"))]
                    : rows
                }
            )
        }
    }
    
    static func detail<Node: Plan.Node>(
        _ detailRow: Plan.DetailRow,
        node: @escaping () async throws -> Node?,
        overridingScene: @escaping (_ path: String, _ node: Node) async throws -> Scene?
    ) -> Self {
        .detail(
            detailRow,
            path: nil,
            node: node,
            overridingScene: overridingScene
        )
    }
    
    static func detail<Node: Plan.Node>(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        node: @escaping () async throws -> Node?,
        overridingScene: @escaping (_ path: String, _ node: Node) async throws -> Scene?
    ) -> Self {
        .detail(
            Plan.DetailRow(title: title, subtitle: subtitle, trailing: trailing),
            node: node,
            overridingScene: overridingScene
        )
    }
    
    // Builds a scene for a Plan.Node by expanding dictionaries and arrays, or returns an overriding scene for matched path and node.
    private static func scene<Node: Plan.Node>(
        node: Node,
        path: String?,
        overridingScene: @escaping (_ path: String, _ node: Node) async throws -> Scene?
    ) async throws -> Scene {
        if let dictionary = node.asDictionary {
            .list(
                sections: [
                    .init(
                        path,
                        rows: dictionary
                            .sorted { $0.key < $1.key }
                            .map { key, node in
                                Self.detail(
                                    defaultRow(title: key, node: node),
                                    path: [path, key]
                                        .compactMap { $0 }
                                        .joined(separator: "."),
                                    node: { node },
                                    overridingScene: overridingScene
                                )
                            }
                    )
                ]
            )
        } else if let array = node.asArray {
            .list(
                sections: [
                    .init(
                        path,
                        rows: array.enumerated()
                            .map { _, node in
                                    .detail(
                                        defaultRow(title: nil, node: node),
                                        path: [path, "[]"]
                                            .compactMap { $0 }
                                            .joined(separator: "."),
                                        node: { node },
                                        overridingScene: overridingScene
                                    )
                            }
                    )
                ]
            )
        } else {
            .list(rows: [.detail("Empty")])
        }
    }
    
    static func detail<Node: Plan.Node>(
        _ detailRow: Plan.DetailRow,
        path: String?,
        node: @escaping () async throws -> Node?,
        overridingScene: @escaping (_ path: String, _ node: Node) async throws -> Scene?
    ) -> Self {
        .detail(detailRow) {
            let node: Node? = try await node()
            let scene: Scene = if
                let node,
                let path,
                let overridingScene = try await overridingScene(path, node)
            {
                overridingScene
            } else if let node {
                try await scene(node: node, path: path, overridingScene: overridingScene)
            } else {
                .list(rows: [.detail("Empty")])
            }
            return scene
        }
    }
    
    static func rows<Node: Plan.Node>(
        dictionary: [String: Node],
        path: String,
        overridingScene: @escaping (_ key: String, _ node: Node) async throws -> Scene?
    ) -> [Self] {
        dictionary
            .sorted { $0.key < $1.key }
            .map { key, node in
                    .detail(
                        defaultRow(title: key, node: node),
                        path: [path, key]
                            .compactMap { $0 }
                            .joined(separator: "."),
                        node: { node },
                        overridingScene: overridingScene
                    )
            }
    }
    
    // MARK: - detailRowForNode
    
    static func detail<Node: Plan.Node>(
        _ title: String,
        trailing: String? = nil,
        subtitle: String? = nil,
        node: @escaping () async throws -> Node?,
        detailRowForNode: ((Node) -> Plan.DetailRow?)? = nil
    ) -> Self {
        .detail(
            .init(title, subtitle: subtitle, trailing: trailing),
            node: node,
            detailRowForNode: detailRowForNode
        )
    }
    
    static func rows<Node: Plan.Node>(
        dictionary: [String: Node],
        detailRowForNode: ((Node) -> Plan.DetailRow?)? = nil
    ) -> [Self] {
        dictionary
            .sorted { $0.key < $1.key }
            .map { key, node in
                    .detail(key, node: node, detailRowForNode: detailRowForNode)
            }
    }
    
    static func rows<Node: Plan.Node>(
        nodes: [Node],
        detailRowForNode: ((Node) -> Plan.DetailRow?)? = nil
    ) -> [Self] {
        nodes
            .map { node in
                    .detail(
                        node: node,
                        detailRowForNode: detailRowForNode
                    )
            }
    }
    
    static func rows<Node: Plan.Node>(
        node: Node?,
        detailRowForNode: ((Node) -> Plan.DetailRow?)? = nil
    ) -> [Self] {
        if let dictionary = node?.asDictionary {
            rows(dictionary: dictionary, detailRowForNode: detailRowForNode)
        } else if let array = node?.asArray {
            rows(nodes: array, detailRowForNode: detailRowForNode)
        } else {
            []
        }
    }
    
}
