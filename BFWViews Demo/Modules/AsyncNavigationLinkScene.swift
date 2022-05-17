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
    
    @State private var isActiveNext = false
    
    func performTask() {
        // Example async task. This would typically be a network fetch, or anything that takes some time.
        DispatchQueue.main.asyncAfter(
            deadline: .now().advanced(by: .seconds(2)),
            execute: .init(
                block: {
                    isActiveNext = true
                }
            )
        )
    }
}

extension AsyncNavigationLinkScene: View {
    var body: some View {
        List {
            AsyncNavigationLink(
                isActive: $isActiveNext,
                destination: { Text("Next Scene") },
                label: {
                    Text("Do something asynchronous")
                },
                action: performTask
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
