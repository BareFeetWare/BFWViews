//
//  ListSceneFlow.Coordinator.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 17/5/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import BFWViews
import SwiftUI

extension ListSceneFlow {
    class Coordinator {
        lazy var firstList: some View = rootView()
    }
}

private extension ListSceneFlow.Coordinator {
    
    func rootView() -> some View {
        Plan.List(
            sections: [
                .init(
                    title: "Static detail",
                    cells: [
                        .init(id: "button") { Button("Button") {}},
                        .detail("Detail 1", trailing: "trailing"),
                        .detail("Detail 2", subtitle: "subtitle", trailing: "trailing"),
                    ]
                ),
                .init(
                    title: "Push Immediate",
                    cells: [
                        .detail("Push 1", trailing: "3") {
                            Plan.List(
                                cells: [
                                    .detail("Child 1"),
                                    .detail("Child 2"),
                                ]
                            )
                            .navigationTitle("Pushed")
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
        .navigationTitle("ListScene")
    }
    
    func asyncChildrenScene() async -> some View {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let children = ["Child 1", "Child 2", "Child 3"]
        return Plan.List(
            cells: children.map { child in
                    .detail(child)
            }
        )
        .navigationTitle("Children")
    }
    
}
