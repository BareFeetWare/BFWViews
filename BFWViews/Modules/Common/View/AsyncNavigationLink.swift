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
public struct AsyncNavigationLink<Destination: View, Label: View & Identifiable> {
    var selection: Binding<Label.ID?>?
    @State private var defaultSelection: Label.ID?
    let destination: () async throws -> Destination
    let label: () -> Label
    @State private var isInProgress = false
    @State private var activeDestination: Destination?
    @State private var error: Error? {
        didSet { isPresentedError = error != nil }
    }
    @State private var isPresentedError = false
    
    public init(
        selection: Binding<Label.ID?>? = nil,
        destination: @escaping () async throws -> Destination,
        label: @escaping () -> Label
    ) {
        self.selection = selection
        self.destination = destination
        self.label = label
    }
    
}

extension AsyncNavigationLink: Identifiable {
    public var id: Label.ID { label().id }
}

private extension AsyncNavigationLink {

    var activeSelectionBinding: Binding<Label.ID?> {
        .init {
            if let selection {
                return selection.wrappedValue
            } else {
                return defaultSelection
            }
        } set: { newValue in
            if let selection {
                selection.wrappedValue = newValue
            } else {
                defaultSelection = newValue
            }
        }
    }
    
    func onTap() {
        isInProgress = true
        Task {
            do {
                activeDestination = try await destination()
                isInProgress = false
                activeSelectionBinding.wrappedValue = id
            } catch {
                self.error = error
            }
        }
    }
}

extension AsyncNavigationLink: View {
    public var body: some View {
        Button {
            onTap()
        } label: {
            NavigationLink(
                tag: label().id,
                selection: activeSelectionBinding,
                destination: { activeDestination },
                label: label
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
    
    struct PreviewScene: View {
        
        @State var selection: String?
        
        var body: some View {
            NavigationView {
                List {
                    AsyncNavigationLink(
                        selection: $selection,
                        destination: asyncDestination,
                        label: {
                            Plan.Cell(id: "async") {
                                Text("Async")
                            }
                        }
                    )
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
        PreviewScene()
    }
}
