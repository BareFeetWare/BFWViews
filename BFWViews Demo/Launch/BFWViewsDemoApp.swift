//
//  BFWViewsDemoApp.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

@main
struct BFWViewsDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MiniSheet())
        }
    }
}
