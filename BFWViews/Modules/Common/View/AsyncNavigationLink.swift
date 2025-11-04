//
//  AsyncNavigationLink.swift
//
//  Created by Tom Brodhurst-Hill on 1/2/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

/**
 Facilitates:
 1. The cell shows a `>` disclosure indicator.
 2. The user taps anywhere on the label/row.
 3. The cell indicator changes to a placeholder, or defaults to a trailing ProgressView.
 4. The app performs the destination(), such as fetching from an API.
 5. When the destination completes, the indicator changes back to a disclosure indicator.
 6. The app moves forward to the destination scene.
 */
public struct AsyncNavigationLink<
    Destination: View,
    Label: View,
    Tag: Hashable,
    Placeholder: View
> {
    let tag: Tag
    let externalSelectionBinding: Binding<Tag?>?
    /// Used internally if no external selection binding is provided.
    @State private var internalSelection: Tag?
    /// Only changes when activeDestination is ready.
    @State private var activeSelection: Tag?
    let destination: () async throws -> Destination
    let label: () -> Label
    let placeholder: (() -> Placeholder)?
    @State private var isInProgress = false
    @State private var activeDestination: Destination?
    @State private var error: Error?
}

// MARK: - Inits

extension AsyncNavigationLink {
    public init(
        tag: Tag,
        selection: Binding<Tag?>? = nil,
        destination: @escaping () async throws -> Destination,
        label: @escaping () -> Label,
        placeholder: @escaping () -> Placeholder
    ) {
        self.tag = tag
        self.externalSelectionBinding = selection
        self.destination = destination
        self.label = label
        self.placeholder = placeholder
    }
}

extension AsyncNavigationLink where Placeholder == EmptyView {
    public init(
        tag: Tag,
        selection: Binding<Tag?>? = nil,
        destination: @escaping () async throws -> Destination,
        label: @escaping () -> Label
    ) {
        self.tag = tag
        self.externalSelectionBinding = selection
        self.destination = destination
        self.label = label
        self.placeholder = nil
    }
}

extension AsyncNavigationLink {
    public init(
        _ title: String,
        tag: Tag,
        selection: Binding<Tag?>? = nil,
        destination: @escaping () async throws -> Destination,
        placeholder: @escaping () -> Placeholder
    ) where Label == Text {
        self.tag = tag
        self.externalSelectionBinding = selection
        self.destination = destination
        self.label = { Text(title) }
        self.placeholder = placeholder
    }
}

// TODO: Remove instances of UUID().uuidString.

extension AsyncNavigationLink where Label == Text, Tag == String {
    
    public init(
        _ title: String,
        destination: @escaping () async throws -> Destination,
        placeholder: @escaping () -> Placeholder
    ) {
        self.tag = UUID().uuidString
        self.externalSelectionBinding = nil
        self.destination = destination
        self.label = { Text(title) }
        self.placeholder = placeholder
    }
    
    public init(
        destination: @escaping () async throws -> Destination,
        label: @escaping () -> Label,
        placeholder: @escaping () -> Placeholder
    ) {
        self.tag = UUID().uuidString
        self.externalSelectionBinding = nil
        self.destination = destination
        self.label = label
        self.placeholder = placeholder
    }
    
}

extension AsyncNavigationLink where Label == Text, Tag == String, Placeholder == EmptyView {
    
    public init(
        _ title: String,
        destination: @escaping () async throws -> Destination
    ) {
        self.tag = UUID().uuidString
        self.externalSelectionBinding = nil
        self.destination = destination
        self.label = { Text(title) }
        self.placeholder = nil
    }
}

extension AsyncNavigationLink where Tag == String, Placeholder == EmptyView {

    public init(
        destination: @escaping () async throws -> Destination,
        label: @escaping () -> Label
    ) {
        self.tag = UUID().uuidString
        self.externalSelectionBinding = nil
        self.destination = destination
        self.label = label
        self.placeholder = nil
    }
    
}

// MARK: - Functions

private extension AsyncNavigationLink {
    
    /// Used by the view
    var selectionBinding: Binding<Tag?> {
        .init {
            externalSelectionBinding?.wrappedValue ?? internalSelection
        } set: { newValue in
            if externalSelectionBinding != nil {
                externalSelectionBinding?.wrappedValue = newValue
            } else {
                internalSelection = newValue
            }
        }
    }
    
    var selection: Tag? {
        get { selectionBinding.wrappedValue }
        set { selectionBinding.wrappedValue = newValue }
    }
    
    var isDisabled: Bool {
        isInProgress
    }
    
    var isVisibleProgress: Bool {
        isInProgress
    }
    
    func activateDestination() {
        DispatchQueue.main.async {
            Task {
                isInProgress = true
                defer {
                    isInProgress = false
                }
                do {
                    activeDestination = try await destination()
                    if selectionBinding.wrappedValue != tag {
                        selectionBinding.wrappedValue = tag
                    }
                    activeSelection = tag
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    func activateDestinationIfNeeded() {
        if selection == tag && activeSelection != tag {
            activateDestination()
        }
    }
    
    func onTap() {
        activateDestination()
    }
    
    func onChange(selection: Tag?) {
        activateDestinationIfNeeded()
    }
    
    func onAppear() {
        activateDestinationIfNeeded()
    }
    
}

// MARK: - Views

extension AsyncNavigationLink: View {
    public var body: some View {
        NavigationLink(tag: tag, selection: selectionBinding) {
            activeDestination
        } label: {
            if isVisibleProgress {
                if let placeholder = placeholder?() {
                    placeholder
                } else {
                    labelView
                        .overlay(alignment: .trailing) {
                            ProgressView()
                        }
                }
            } else {
                labelView
            }
        }
        .disabled(isDisabled)
    }
    
    var labelView: some View {
        label()
            .frame(maxWidth: .infinity, alignment: .leading)
        // Note: .contentShape(Rectangle()) is required to extend the tappable area across the whole cell width.
            .contentShape(Rectangle())
            .onTapGesture { onTap() }
            .onChange(of: selection) { onChange(selection: $0) }
            .onAppear { onAppear() }
            .alert(error: $error)
    }
}

// MARK: - Previews

public struct AsyncNavigationLink_Previews: PreviewProvider {
    
    public struct Preview: View {
        
        public init() {}
        
        @State var selection: String?
        
        public var body: some View {
            List {
                Section("External selection") {
                    AsyncNavigationLink(
                        tag: "1",
                        selection: $selection,
                        destination: {
                            try await asyncDestination(
                                title: "Async Destination 1"
                            )
                        },
                        label: { Text("Async 1") }
                    )
                    AsyncNavigationLink(
                        tag: "2",
                        selection: $selection,
                        destination: {
                            try await asyncDestination(
                                title: "Async Destination 2"
                            )
                        },
                        label: { Text("Async 2") }
                    )
                }
                Section("Internal selection") {
                    AsyncNavigationLink("Async 3") {
                        try await asyncDestination(
                            title: "Async Destination 3"
                        )
                    }
                    AsyncNavigationLink("Async 4") {
                        try await asyncDestination(
                            title: "Async Destination 4"
                        )
                    }
                    AsyncNavigationLink(tag: "5") {
                        try await asyncDestination(
                            title: "Async Destination 5"
                        )
                    } label: {
                        Text("Async 5")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } placeholder: {
                        Text("Loading...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    AsyncNavigationLink("Non async 6") {
                        Text("Non async Destination 6")
                    }
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
            .navigationTitle("AsyncNavigationLink")
        }
        
        /// Dummy asyc destination, delayed by a timer. Typically this would instead be an async API call.
        func asyncDestination(title: String) async throws -> some View {
            // Arbitrary delay, pretending to be an async request.
            try await Task.sleep(nanoseconds: 2000000000)
            return Text(title)
        }
    }
    
    public static var previews: some View {
        NavigationView {
            Preview()
        }
    }
}
