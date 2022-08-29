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
                        .init("Title", trailing: "3") { [weak self] in
                            guard let self = self else { return }
                            self.fetchPeripherals(sourceViewModel: viewModel)
                        }
                    ),
                ]
            ),
        ]
        return viewModel
    }
    
    func fetchPeripherals(sourceViewModel: ListScene.ViewModel) {
        // Pretend async request
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(2))) {
            let peripherals = ["Peripheral 1", "Peripheral 2", "Peripheral 3"]
            sourceViewModel.destinationViewModel = .init(
                title: "Peripherals",
                cells: peripherals.map { peripheral in
                        .detail(.init(peripheral))
                }
            )
        }
    }
}
