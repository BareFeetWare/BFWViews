//
//  AsyncNavigationLink.swift
//
//  Created by Tom Brodhurst-Hill on 1/2/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

/**
 Facilitates:
 1. The cell shows a `>` disclosure indicator.
 2. The user taps anywhere on the label/row.
 3. The cell indicator changes to a ProgressView.
 4. The app performs the asyncDestination, such as a fetching from an API.
 5. When the asyncDestination completes, the indicator changes back to a disclosure indicator.
 6. The app moves forward to the destination scene.
 7. No error handling yet.
 */
public struct AsyncNavigationLink<Destination: View, Label: View> {
    @State var isActive: Bool = false
    let destination: () async -> Destination
    let label: () -> Label
    @State private var isInProgress = false
    @State private var activeDestination: Destination?
    
    public init(
        destination: @escaping () async -> Destination,
        label: @escaping () -> Label
    ) {
        self.destination = destination
        self.label = label
    }
    
}

extension AsyncNavigationLink: Identifiable where Label: Identifiable {
    public var id: Label.ID { label().id }
}

extension AsyncNavigationLink {
    func onTap() {
        isInProgress = true
        Task {
            activeDestination = await destination()
            isInProgress = false
            isActive = true
        }
    }
}

extension AsyncNavigationLink: View {
    public var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                HStack {
                    label()
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .opacity(isInProgress ? 1 : 0)
                NavigationLink(
                    isActive: $isActive,
                    destination: { activeDestination },
                    label: label
                )
                .opacity(isInProgress ? 0 : 1)
            }
        }
        .foregroundColor(.primary)
    }
}

struct AsyncNavigationLink_Previews: PreviewProvider {
    
    struct PreviewScene: View {
        var body: some View {
            NavigationView {
                List {
                    AsyncNavigationLink(
                        destination: asyncDestination,
                        label: {
                            Text("Async")
                        }
                    )
                }
            }
        }
        
        /// Dummy asyc destination, delayed by a timer. Typically this would instead be an async API call.
        func asyncDestination() async -> some View {
            // Arbitrary delay, pretending to be an async request.
            try? await Task.sleep(nanoseconds: 2000000000)
            return Text("Async Destination")
        }
    }
    
    static var previews: some View {
        PreviewScene()
    }
}
