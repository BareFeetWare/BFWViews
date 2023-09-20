//
//  AsyncNavigationLinkScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 16/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct AsyncNavigationLinkScene {
    
    /// Dummy asyc destination, delayed by a timer. Typically this would instead be an async API call.
    func asyncDestination() async -> some View {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        return Text("Async Destination")
    }
    
}

extension AsyncNavigationLinkScene: View {
    var body: some View {
        List {
            AsyncNavigationLink(
                destination: asyncDestination,
                label: {
                    Plan.Cell(id: "1") {
                        Text("Do something asynchronous")
                    }
                }
            )
        }
        .navigationTitle("AsyncNavigationLink")
    }
}

struct AsyncNavigationLinkScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AsyncNavigationLinkScene()
        }
    }
}
