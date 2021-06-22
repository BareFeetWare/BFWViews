//
//  ContentView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ContentView: View {
    
    @EnvironmentObject var miniSheet: MiniSheet
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Alert+Error", destination: AlertScene())
                NavigationLink("AsyncNavigationLink", destination: AsyncNavigationLinkScene())
                NavigationLink("Card", destination: CardScene())
                NavigationLink("CompressibleSpacer", destination: CompressibleSpacerScene())
                NavigationLink("Distributed", destination: DistributedScene())
                NavigationLink("ImageSymbol", destination: ImageSymbolScene())
                NavigationLink("MiniSheet", destination: MiniSheetScene())
                NavigationLink("ReadFrame", destination: ReadFrameScene())
                NavigationLink("Trailing", destination: TrailingScene())
            }
            .navigationTitle("BFWViews")
        }
        .overlay(miniSheet.overlay)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
