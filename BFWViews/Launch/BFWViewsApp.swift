//
//  BFWViewsApp.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//

import SwiftUI

@main
struct BFWViewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MiniSheet())
        }
    }
}
