//
//  Plan.NavigationLink.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct NavigationLink<Label: View, Destination: View> {
        public let label: Label
        public let title: String?
        public let style: Style
        public let isActive: Binding<Bool>?
        public let dispatch: Dispatch<Destination>
        
        // TODO: Extract these properties into Plan.Modal.
        @State private var internalIsPresented = false
        @State private var isInProgress = false
        @State private var presentedDestination: Destination?
        @State private var alert: Plan.Alert?
    }
}

// MARK: - Types

public extension Plan.NavigationLink {
    enum Style {
        case push
        case sheet
        case cover
    }
}

// MARK: - Convenience Inits

public extension Plan.NavigationLink {
    
    init(
        label: Label,
        title: String?,
        style: Style = .push,
        isActive: Binding<Bool>? = nil,
        destination: Destination
    ) {
        self.label = label
        self.title = title
        self.style = style
        self.isActive = isActive
        self.dispatch = .sync(destination)
    }
    
    init(
        label: Label,
        title: String?,
        style: Style = .push,
        isActive: Binding<Bool>? = nil,
        destination: @escaping () async throws -> Destination
    ) {
        self.label = label
        self.title = title
        self.style = style
        self.isActive = isActive
        self.dispatch = .async(destination)
    }
    
}

// MARK: - Functions

private extension Plan.NavigationLink {
    
    var isPresentedModal: Binding<Bool> {
        isActive ?? $internalIsPresented
    }
    
    var isDisabled: Bool {
        isInProgress || isPresentedModal.wrappedValue
    }
    
    func onTap(destination: @escaping () async throws -> Destination) {
        isInProgress = true
        defer { isInProgress = false }
        withErrorAlert($alert) {
            presentedDestination = try await destination()
            isPresentedModal.wrappedValue = true
        }
    }
    
    var isFullScreenCover: Bool {
        style == .cover
    }
}

private extension View {
    
    @ViewBuilder
    func modal<Content: View>(
        isPresented: Binding<Bool>,
        isFullScreen: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        if isFullScreen {
            fullScreenCover(isPresented: isPresented, content: content)
        } else {
            sheet(isPresented: isPresented, content: content)
        }
    }
}

// MARK: - Views

extension Plan.NavigationLink: View {
    public var body: some View {
        switch style {
        case .cover, .sheet:
            switch dispatch {
            case .async(let destination):
                label
                    .onTapGesture { onTap(destination: destination) }
                    .disabled(isDisabled)
                    .modal(isPresented: isPresentedModal, isFullScreen: isFullScreenCover) {
                        NavigationStack {
                            presentedDestination
                                .ifLet(title) { title, view in
                                    view.navigationTitle(title)
                                }
                        }
                    }
                    .alert($alert)
            case .sync(let destination):
                label
                    .sheet(isPresented: isPresentedModal) {
                        destination
                    }
            }
        case .push:
            switch dispatch {
            case .async(let destination):
                AsyncNavigationLink {
                    try await destination()
                        .ifLet(title) { title, view in
                            view.navigationTitle(title)
                        }
                } label: {
                    label
                }
            case .sync(let destination):
                NavigationLink {
                    destination
                        .ifLet(title) { title, view in
                            view.navigationTitle(title)
                        }
                } label: {
                    label
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        List {
            Plan.NavigationLink(
                label: Text("Label"),
                title: "Title",
                destination: Text("Destination")
            )
            Plan.NavigationLink(
                label: Text("Present Sheet"),
                title: "Sheet",
                style: .sheet,
                destination: Text("Sheet")
            )
        }
    }
}
