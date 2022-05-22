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
                        switch cell {
                        case .button(let button):
                            Button(button.title, action: button.action)
                        case .detail(let detail):
                            AsyncNavigationLink(
                                isActive: $viewModel.isActiveDestination,
                                destination: { viewModel.destinationViewModel.map { ListScene(viewModel: $0) }},
                                label: { DetailCell(viewModel: detail.detailCellViewModel) },
                                action: detail.onTap
                            )
                        }
                    }
                } header: {
                    section.title.map { Text($0) }
                }
            }
        }
        .textCase(.none)
        .navigationTitle(viewModel.title)
    }
}

struct ListScene_Previews: PreviewProvider {
    static var previews: some View {
        ListScene(viewModel: .preview)
    }
}