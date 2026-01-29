//
//  ListScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 17/5/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import BFWViews
import SwiftUI

struct ListScene {
    typealias List = Plan.List<Plan.Row, Scene>
    typealias Scene = Plan.Scene
}

// MARK: - Functions

private extension ListScene {
    
    var list: List {
        .init(
            sections: [
                .init(
                    "Static detail",
                    cells: [
                        .button("Button") {},
                        .detail("Detail 1", trailing: "trailing"),
                        .detail("Detail 2", subtitle: "subtitle", trailing: "trailing"),
                    ]
                ),
                .init(
                    "Push Immediate",
                    cells: [
                        .detail("Push 1", trailing: "3") {
                            .list(
                                cells: [
                                    .detail("Child 1"),
                                    .detail("Child 2"),
                                ]
                            )
                        },
                    ]
                ),
                .init(
                    "Push Async",
                    cells: [
                        .detail("Push 2", trailing: "3") {
                            await self.asyncChildrenScene()
                        },
                    ]
                ),
            ]
        )
    }
    
    func asyncChildrenScene() async -> Scene {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let children = ["Child 1", "Child 2", "Child 3"]
        return .list(
            cells: children.map { child in
                    .detail(child)
            }
        )
    }
    
}

// MARK: - Views

extension ListScene: View {
    var body: some View {
        list
    }
}

// MARK: - Previews

#Preview {
    NavigationView {
        ListScene()
    }
}
