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
                        if let destination = cell.destination {
                            AsyncNavigationLink(
                                isActive: $viewModel.isActiveDestination,
                                destination: { viewModel.destination.map { AnyView($0.view()) }},
                                label: { AnyView(cell.viewModel.view()) },
                                action: viewModel.action(destination: destination)
                            )
                        } else {
                            AnyView(cell.viewModel.view())
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
        .listStyle(viewModel.listStyle)
        .navigationTitle(viewModel.title)
    }
}

extension ListScene.ViewModel: ViewShowable {
    public func view() -> some View {
        ListScene(viewModel: self)
    }
}

struct ListScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListScene(viewModel: .preview)
        }
    }
}
