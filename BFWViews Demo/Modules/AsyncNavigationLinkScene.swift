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
    @State private var isInProgressTask = false
    
    func performTask() {
        // Example async task. This would typically be a network fetch, or anything that takes some time.
        DispatchQueue.main.asyncAfter(
            deadline: .now().advanced(by: .seconds(2)),
            execute: .init(
                block: {
                    isActiveNext = true
                    isInProgressTask = false
                }
            )
        )
    }
}

extension AsyncNavigationLinkScene: View {
    var body: some View {
        List {
            AsyncNavigationLink(
                destination: Text("Next Scene"),
                isActive: $isActiveNext,
                isInProgress: $isInProgressTask,
                action: performTask
            ) {
                Text("Do something asynchronous")
            }
        }
        .navigationTitle("AsyncNavigationLink")
    }
}

struct AsyncNavigationLinkScene_Previews: PreviewProvider {
    static var previews: some View {
        AsyncNavigationLinkScene()
    }
}
