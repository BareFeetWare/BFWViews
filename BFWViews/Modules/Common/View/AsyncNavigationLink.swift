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
 4. The app performs the destination(), such as fetching from an API.
 5. When the destination completes, the indicator changes back to a disclosure indicator.
 6. The app moves forward to the destination scene.
 7. No error handling yet.
 */
public struct AsyncNavigationLink<Destination: View, Label: View, Tag: Hashable> {
    let tag: Tag
    let selection: Binding<Tag?>?
    /// Only changes when activeDestination is ready.
    @State private var activeSelection: Tag?
    let destination: () async throws -> Destination
    let label: () -> Label
    @State private var isInProgress = false
    @State private var activeDestination: Destination?
    @State private var error: Error? {
        didSet { isPresentedError = error != nil }
    }
    @State private var isPresentedError = false
    
    public init(
        tag: Tag,
        selection: Binding<Tag?>? = nil,
        destination: @escaping () async throws -> Destination,
        label: @escaping () -> Label
    ) {
        self.tag = tag
        self.selection = selection
        self.destination = destination
        self.label = label
    }
    
}

private extension AsyncNavigationLink {
    
    func activateDestination() {
        DispatchQueue.main.async {
            isInProgress = true
            Task {
                do {
                    activeDestination = try await destination()
                    activeSelection = tag
                    isInProgress = false
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    func onTap() {
        activateDestination()
    }
    
    /// Observe changes to selection binding.
    var bindingObserver: String {
        let selection = selection
        if selection?.wrappedValue == tag && activeSelection != tag {
            activateDestination()
        }
        return ""
    }
}

extension AsyncNavigationLink: View {
    public var body: some View {
        Button {
            onTap()
        } label: {
            NavigationLink(
                tag: tag,
                selection: $activeSelection,
                destination: { activeDestination },
                label: label
            )
            .overlay(
                Text(bindingObserver)
            )
            .foregroundColor(.primary)
            .overlay(
                Group {
                    if isInProgress {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                },
                alignment: .trailing
            )
        }
        .alert(isPresented: $isPresentedError) {
            Alert(error: error)
        }
    }
}

struct AsyncNavigationLink_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State var selection: String?
        
        var body: some View {
            NavigationView {
                List {
                    Section {
                        AsyncNavigationLink(
                            tag: "1",
                            selection: $selection,
                            destination: asyncDestination,
                            label: { Text("Async 1") }
                        )
                        AsyncNavigationLink(
                            tag: "2",
                            selection: $selection,
                            destination: asyncDestination,
                            label: { Text("Async 2") }
                        )
                    }
                    Section {
                        Button("Activate 1") {
                            selection = "1"
                        }
                        Button("Activate 2") {
                            selection = "2"
                        }
                    }
                }
            }
        }
        
        /// Dummy asyc destination, delayed by a timer. Typically this would instead be an async API call.
        func asyncDestination() async throws -> some View {
            // Arbitrary delay, pretending to be an async request.
            try await Task.sleep(nanoseconds: 2000000000)
            return Text("Async Destination")
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
