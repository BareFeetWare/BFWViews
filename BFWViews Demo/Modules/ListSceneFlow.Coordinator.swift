//
//  ListSceneFlow.Coordinator.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 17/5/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import BFWViews

extension ListSceneFlow {
    class Coordinator {
        lazy var firstList: Plan.List = rootList()
    }
}

private extension ListSceneFlow.Coordinator {
    
    func rootList() -> Plan.List {
        let viewModel = Plan.List(
            title: "ListScene",
            sections: []
        )
        viewModel.sections = [
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
                        Plan.List(
                            title: "Pushed",
                            cells: [
                                .detail("Child 1"),
                                .detail("Child 2"),
                            ]
                        )
                    },
                ]
            ),
            .init(
                title: "Push Async",
                cells: [
                    .detail("Push 2", trailing: "3") {
                        await self.childrenList()
                    },
                ]
            ),
        ]
        return viewModel
    }
    
    func childrenList() async -> Plan.List {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let children = ["Child 1", "Child 2", "Child 3"]
        return .init(
            title: "Children",
            cells: children.map { child in
                    .detail(child)
            }
        )
    }
    
}
