//
//  ListSceneFlow.Coordinator.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 17/5/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import BFWViews
// TODO: Remove:
import SwiftUI

extension ListSceneFlow {
    class Coordinator {
        lazy var firstList: some View = rootView()
    }
}

private extension ListSceneFlow.Coordinator {
    
    func rootView() -> Plan.ListScene {
        .init(
            title: "ListScene",
            sections: [
                .init(
                    title: "Static detail",
                    cells: [
                        .button("Button") {},
                        .detail("Detail 1", trailing: "trailing"),
                        .detail("Detail 2", subtitle: "subtitle", trailing: "trailing"),
                    ]
                ),
                .init(
                    title: "Push Immediate",
                    cells: [
                        .detail("Push 1", trailing: "3") {
                            Plan.NavigationItem(
                                title: "Pushed",
                                content: Plan.List(
                                    cells: [
                                        .detail("Child 1"),
                                        .detail("Child 2"),
                                    ]
                                )
                            )
                        },
                    ]
                ),
                .init(
                    title: "Push Async",
                    cells: [
                        .detail("Push 2", trailing: "3") {
                            await self.asyncChildrenScene()
                        },
                    ]
                ),
            ]
        )
    }
    
    func asyncChildrenScene() async -> some View {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let children = ["Child 1", "Child 2", "Child 3"]
        return Plan.ListScene(
            title: "Children",
            cells: children.map { child in
                    .detail(child)
            }
        )
    }
    
}
