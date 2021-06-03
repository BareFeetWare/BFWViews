//
//  CompressibleSpacerScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 3/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct CompressibleSpacerScene {}

extension CompressibleSpacerScene: View {
    var body: some View {
        List {
            HStack {
                Text("Leading")
                CompressibleSpacer()
                Text("Trailing")
                    .multilineTextAlignment(.trailing)
            }
        }
        .navigationTitle("CompressibleSpacer")
    }
}

struct CompressibleSpacerScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CompressibleSpacerScene()
        }
    }
}
