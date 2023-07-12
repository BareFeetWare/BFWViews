//
//  Plan.Section+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/7/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Section: View {
    public var body: some View {
        if #available(iOS 17.0, *) {
            Section(isExpanded: $isExpanded) {
                ForEach(cells) { $0 }
            } header: {
                headerView
            }
        } else {
            Section {
                if isExpanded {
                    ForEach(cells) { $0 }
                }
            } header: {
                headerView
            }
        }
    }
    
    var headerView: some View {
        HStack {
            header.map {
                AnyView($0)
                    .textCase(nil)
            }
            if isExpandable {
                Spacer()
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(symbol: .chevronRight)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
        }
    }
}

struct PlanSection_Previews: PreviewProvider {
    static var previews: some View {
        Plan.List(
            sections: [
                Plan.Section(
                    isExpandable: true,
                    header: Text("expandable"),
                    cells: [
                        .detail("cell 1"),
                        .detail("cell 2"),
                    ]
                ),
                Plan.Section(
                    isExpandable: false,
                    header: Text("not expandable"),
                    cells: [
                        .detail("cell 1"),
                        .detail("cell 2"),
                    ]
                ),
            ]
        )
    }
}
