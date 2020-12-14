//
//  ContentView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var miniSheetManager: MiniSheet.Manager
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("MiniSheet", destination: MiniSheetScene())
            }
            .navigationTitle("BFWViews")
        }
        .overlay(miniSheetManager.overlay)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
