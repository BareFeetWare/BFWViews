//
//  ContentView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ContentView {}

// MARK: - Functions

private extension ContentView {
    
    var cells: [Plan.Cell] {
        [
            .detail("Alert") { AlertScene() },
            .detail("AsyncImage") { AsyncImageScene() },
            .detail("AsyncNavigationLink") { AsyncNavigationLinkScene() },
            .detail("Badge") { BadgeScene() },
            .detail("Card") { CardScene() },
            .detail("CellBorder") { CellBorderScene() },
            .detail("Color+Hex") { ColorHexScene() },
            .detail("CompressibleSpacer") { CompressibleSpacerScene() },
            .detail("Distributed") { DistributedScene() },
            .detail("ImageSymbol") { ImageSymbolScene() },
            .detail("Plan.List") { ListSceneFlow() },
            .detail("ReadFrame") { ReadFrameScene() },
            .detail("TappableCell") { TappableCellScene() },
            .detail("Trailing") { TrailingScene() },
            .detail("UIView") { UIViewScene() },
            .detail("UIViewController") { UIViewControllerScene() },
            .detail("WebView") { WebScene() },
        ]
    }
    
}

// MARK: - Views

extension ContentView: View {
    var body: some View {
        NavigationView {
            List(cells.identified) { $0 }
                .navigationTitle("BFWViews")
        }
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
