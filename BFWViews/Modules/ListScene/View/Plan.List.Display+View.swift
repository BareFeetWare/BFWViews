//
//  Plan.List.Display+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.List.Display: View {
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

extension Plan.List: ViewShowable {
    public func view() -> some View {
        Display(viewModel: self)
    }
}

struct PlanListDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Plan.List.Display(viewModel: .preview)
        }
    }
}
