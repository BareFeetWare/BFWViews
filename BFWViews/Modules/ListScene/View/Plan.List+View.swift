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
                        cell
                    }
                } header: {
                    section.header.map {
                        AnyView($0)
                            .textCase(nil)
                    }
                }
            }
        }
    }
}

struct PlanListDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Plan.List.preview
        }
    }
}
