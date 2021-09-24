//
//  ContentView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ContentView {
    @EnvironmentObject var miniSheet: MiniSheet
}

extension ContentView: View {
    var body: some View {
        NavigationView {
            List(cells) { cell in
                NavigationLink(cell.name, destination: cell.destination)
            }
            .navigationTitle("BFWViews")
        }
        .overlay(miniSheet.overlay)
    }
}

private extension ContentView {
    
    struct Cell: Identifiable {
        let id = UUID()
        let name: String
        let destination: AnyView
    }
    
    var cells: [Cell] {
        [
            .init(name: "Alert+Error", destination: AnyView(AlertScene())),
            .init(name: "AsyncNavigationLink", destination: AnyView(AsyncNavigationLinkScene())),
            .init(name: "Card", destination: AnyView(CardScene())),
            .init(name: "Color+Hex", destination: AnyView(ColorHexScene())),
            .init(name: "CompressibleSpacer", destination: AnyView(CompressibleSpacerScene())),
            .init(name: "Distributed", destination: AnyView(DistributedScene())),
            .init(name: "ImageLoader", destination: AnyView(ImageLoaderScene())),
            .init(name: "ImageSymbol", destination: AnyView(ImageSymbolScene())),
            .init(name: "MiniSheet", destination: AnyView(MiniSheetScene())),
            .init(name: "ReadFrame", destination: AnyView(ReadFrameScene())),
            .init(name: "SVGLoader", destination: AnyView(SVGLoaderScene())),
            .init(name: "TappableCell", destination: AnyView(TappableCellScene())),
            .init(name: "Trailing", destination: AnyView(TrailingScene())),
        ]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
