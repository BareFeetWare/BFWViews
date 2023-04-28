//
//  ListScene.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct ListScene {
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension ListScene: View {
    public var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.cells) { cell in
                        if let destinationSceneViewModel = cell.listSceneViewModel {
                            AsyncNavigationLink(
                                isActive: $viewModel.isActiveDestination,
                                destination: { viewModel.destinationViewModel.map { ListScene(viewModel: $0) }},
                                label: { cell.view() },
                                action: viewModel.action(destinationSceneViewModel: destinationSceneViewModel)
                            )
                        } else {
                            cell.view()
                        }
                    }
                } header: {
                    section.title.map {
                        Text($0)
                            .textCase(nil)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}

struct ListScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListScene(viewModel: .preview)
        }
    }
}
