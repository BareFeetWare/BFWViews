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
                        .init("title", id: "2", trailing: "trailing")
                    ),
                    .detail(
                        .init("title", id: "3", subtitle: "subtitle", trailing: "trailing")
                    ),
                ]
            ),
            .init(
                title: "Async",
                cells: [
                    .detail(
                        .init(
                            "Title",
                            trailing: "3",
                            destinationSceneViewModel: peripheralsSceneViewModel
                        )
                    ),
                ]
            ),
        ]
        return viewModel
    }
    
    func peripheralsSceneViewModel() async -> ListScene.ViewModel {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let peripherals = ["Peripheral 1", "Peripheral 2", "Peripheral 3"]
        return .init(
            title: "Peripherals",
            cells: peripherals.map { peripheral in
                    .detail(.init(peripheral))
            }
        )
    }
    
}
