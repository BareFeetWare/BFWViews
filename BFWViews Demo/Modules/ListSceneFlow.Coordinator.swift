//
//  DemoListScene.swift
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
            title: "Bluetooth",
            sections: []
        )
        viewModel.sections = [
            .init(
                title: "Bluetooth Central Manager",
                cells: [
                    .button(
                        .init(title: "Start", action: {})
                    ),
                    .detail(
                        .init("Status", trailing: "Off line")
                    ),
                    .button(
                        .init(title: "Scan", action: {})),
                ]
            ),
            .init(
                title: "Devices",
                cells: [
                    .detail(
                        .init("Peripherals", trailing: "3") { [weak self] in
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
