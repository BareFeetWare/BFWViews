//
//  TappableCellScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 22/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct TappableCellScene {
    @State private var isExpanded = false
    @State private var isActivePush = false
}

extension TappableCellScene: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NavigationLink(
                    destination: Text("Pushed"),
                    isActive: $isActivePush,
                    label: {
                        Text("Push")
                            .tappableCell {
                                isActivePush = true
                            }
                    }
                )
                Divider()
                Text("Expand")
                    .tappableCell(symbol: isExpanded ? .chevronDown : .chevronUp) {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
                if isExpanded {
                    Text("Expanded Content")
                        .padding(.leading)
                }
                Divider()
                NavigationLink("NavigationLink, for comparison", destination: Text("Test"))
            }
            .padding()
        }
        .navigationTitle("TappableCell")
    }
}


struct TappableCellScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TappableCellScene()
        }
    }
}
