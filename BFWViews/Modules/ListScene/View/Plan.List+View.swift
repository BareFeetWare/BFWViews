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
        List(selection: selection) {
            ForEach(sections.compactMap { $0 }) { $0 }
        }
    }
}

struct PlanListDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Plan.List<String>.Preview().list
                .navigationTitle("Plan.List")
        }
    }
}
