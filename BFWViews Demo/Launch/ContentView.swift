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
    
    var cells: [Plan.Simple.Cell] {
        [
            .push("Alert") { AlertScene() },
            .push("AsyncImage") { AsyncImageScene() },
            .push("AsyncNavigationLink") { AsyncNavigationLinkScene() },
            .push("Badge") { BadgeScene() },
            .push("Card") { CardScene() },
            .push("CellBorder") { CellBorderScene() },
            .push("Color+Hex") { ColorHexScene() },
            .push("CompressibleSpacer") { CompressibleSpacerScene() },
            .push("Distributed") { DistributedScene() },
            .push("ImageSymbol") { ImageSymbolScene() },
            .push("Plan.List") { ListScene() },
            .push("ReadFrame") { ReadFrameScene() },
            .push("TappableCell") { TappableCellScene() },
            .push("Trailing") { TrailingScene() },
            .push("UIView") { UIViewScene() },
            .push("UIViewController") { UIViewControllerScene() },
            .push("WebView") { WebScene() },
        ]
    }
    
}

// MARK: - Views

extension ContentView: View {
    var body: some View {
        NavigationView {
            List(cells.identified()) { $0 }
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
