//
//  TrailingScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 3/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct TrailingScene {
    let optionalString: String? = nil
}

extension TrailingScene: View {
    var body: some View {
        List {
            Text("leading")
                .trailing { Text("trailing") }
            Text("nothing trailing")
                .trailing {
                    optionalString.map { Text($0) }
                }
        }
        .navigationTitle("Trailing")
    }
}

struct TrailingScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrailingScene()
        }
    }
}
