//
//  Plan.ListScene+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 10/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.ListScene: View {
    public var body: some View {
        navigationItem
    }
}

struct Plan_ListScene_Previews: PreviewProvider {
    static var previews: some View {
        Plan.ListScene(
            title: "ListScene",
            sections: [
                .init(
                    title: "Section",
                    cells: [
                        .detail("cell 1"),
                        .detail("cell 2"),
                    ]
                ),
            ]
        )
    }
}
