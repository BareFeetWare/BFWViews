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
    
    typealias Cell = Plan.Cell<Plan.Row, Plan.Scene>
    
    var cells: [Cell] {
        [
            .detail("Alert") { .view(AlertScene()) },
            .detail("AsyncImage") { .view(AsyncImageScene()) },
            .detail("AsyncNavigationLink") { .view(AsyncNavigationLinkScene()) },
            .detail("Badge") { .view(BadgeScene()) },
            .detail("Card") { .view(CardScene()) },
            .detail("CellBorder") { .view(CellBorderScene()) },
            .detail("Color+Hex") { .view(ColorHexScene()) },
            .detail("CompressibleSpacer") { .view(CompressibleSpacerScene()) },
            .detail("Distributed") { .view(DistributedScene()) },
            .detail("ImageSymbol") { .view(ImageSymbolScene()) },
            .detail("Plan.List") { .view(ListScene()) },
            .detail("ReadFrame") { .view(ReadFrameScene()) },
            .detail("TappableCell") { .view(TappableCellScene()) },
            .detail("Trailing") { .view(TrailingScene()) },
            .detail("UIView") { .view(UIViewScene()) },
            .detail("UIViewController") { .view(UIViewControllerScene()) },
            .detail("WebView") { .view(WebScene()) },
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
