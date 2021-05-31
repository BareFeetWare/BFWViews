//
//  BFWViewsDemoApp.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//

import SwiftUI

@main
struct BFWViewsDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MiniSheet())
        }
    }
}
