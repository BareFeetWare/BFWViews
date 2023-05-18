//
//  Plan.List+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.List: View {
    public var body: some View {
        List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.cells) { cell in
                        if let destination = cell.destination {
                            AsyncNavigationLink(
                                isActive: $state.isActiveDestination,
                                destination: { state.destination.map { AnyView($0) }},
                                label: { AnyView(cell.content) },
                                action: action(destination: destination)
                            )
                        } else {
                            AnyView(cell.content)
                        }
                    }
                } header: {
                    section.header.map {
                        AnyView($0)
                            .textCase(nil)
                    }
                }
            }
        }
        .listStyle(listStyle)
    }
}

struct PlanListDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Plan.List.preview
        }
    }
}
