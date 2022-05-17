//
//  ImageSymbolScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 3/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ImageSymbolScene {
    let symbols: [ImageSymbol] = [
        .battery0,
        .battery25,
        .battery100,
        .arrowUpCircleFill
    ]
}

extension ImageSymbolScene: View {
    var body: some View {
        List {
            ForEach(0 ..< symbols.count, id: \.self) { index in
                HStack {
                    Image(symbol: symbols[index])
                        .frame(width: 44)
                    Text(String(describing: symbols[index]))
                    Spacer()
                    Text(String(describing: symbols[index].rawValue))
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("ImageSymbol")
    }
}

struct ImageSymbolScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageSymbolScene()
        }
    }
}
