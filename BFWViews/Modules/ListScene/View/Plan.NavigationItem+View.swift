//
//  Plan.NavigationItem+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 9/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.NavigationItem: View {
    public var body: some View {
        if let title = title {
            AnyView(content)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(titleDisplayMode)
        } else {
            AnyView(content)
        }
    }
}

struct Plan_NavigationItem_View_Previews: PreviewProvider {
    static var previews: some View {
        Plan.NavigationItem(
            title: "Title",
            content: { Text("content") }()
        )
    }
}
