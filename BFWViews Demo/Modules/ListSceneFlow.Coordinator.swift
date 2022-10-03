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
        lazy var firstSceneViewModel: ListScene.ViewModel = rootListSceneViewModel()
    }
}

private extension ListSceneFlow.Coordinator {
    
    func rootListSceneViewModel() -> ListScene.ViewModel {
        let viewModel = ListScene.ViewModel(
            title: "ListScene",
            sections: []
        )
        viewModel.sections = [
            .init(
                title: "Static detail",
                cells: [
                    .button(
                        .init(title: "Button", action: {})
                    ),
                    .detail(
                        .init(title: "Detail 1", trailing: "trailing")
                    ),
                    .detail(
                        .init(title: "Detail 2", subtitle: "subtitle", trailing: "trailing")
                    ),
                ]
            ),
            .init(
                title: "Push",
                cells: [
                    .push(
                        .init(
                            title: "Push 1",
                            trailing: "3"
                        ),
                        childrenSceneViewModel
                    ),
                ]
            ),
        ]
        return viewModel
    }
    
    func childrenSceneViewModel() async -> ListScene.ViewModel {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let children = ["Child 1", "Child 2", "Child 3"]
        return .init(
            title: "Children",
            cells: children.map { child in
                    .detail(.init(title: child))
            }
        )
    }
    
}
