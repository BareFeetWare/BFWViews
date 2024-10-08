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
    let symbols: [String: ImageSymbol] = [
        ".battery0": .battery0,
        ".battery25": .battery25,
        ".battery100": .battery100,
        ".arrowUp": .arrowUp
    ]
    
    var symbolKeys: [String] { Array(symbols.keys).sorted() }
}

extension ImageSymbolScene: View {
    var body: some View {
        List {
            ForEach(symbolKeys, id: \.self) { key in
                let symbol = symbols[key]!
                HStack {
                    Image(symbol: symbol)
                        .frame(width: 32)
                    Text(key)
                    Spacer()
                    Text(symbol.name)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
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
