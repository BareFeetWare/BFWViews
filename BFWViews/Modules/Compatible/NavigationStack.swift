//
//  NavigationStack.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 21/1/2026.
//

import SwiftUI

/// Backward-compatible `NavigationStack` for iOS 15+.
///
/// Two flavours:
/// - **No-path:** `NavigationStack { root }`. On iOS 16+ delegates to
///   `SwiftUI.NavigationStack(root:)`; on iOS 15 wraps `NavigationView`.
/// - **Path-based:** `NavigationStack(path:destination:content:)`. On iOS
///   16+ delegates to `SwiftUI.NavigationStack(path:)` and applies
///   `.navigationDestination(for: Element.self)` on the content. On iOS
///   15 wraps `NavigationView` and chains hidden
///   `NavigationLink(isActive:)`s — one per path element — so a push
///   appends to `path` and a pop truncates it.
///
/// The path-based init takes the destination resolver as a parameter
/// rather than via a separate `.navigationDestination(for:)` modifier,
/// because shimming that modifier on iOS 15 would require env-based
/// destination registration. Call sites pass the resolver inline.
public struct NavigationStack<Element: Hashable, Destination: View, Content: View> {
    let path: Binding<[Element]>?
    let destination: ((Element) -> Destination)?
    let content: () -> Content
    
    /// No-path init.
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) where Element == Int, Destination == EmptyView {
        self.path = nil
        self.destination = nil
        self.content = content
    }
    
    /// Path-based init with a destination resolver for each element.
    public init(
        path: Binding<[Element]>,
        @ViewBuilder destination: @escaping (Element) -> Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.path = path
        self.destination = destination
        self.content = content
    }
}

// MARK: - Views

extension NavigationStack: View {
    public var body: some View {
        if let path, let destination {
            pathBody(path: path, destination: destination)
        } else {
            noPathBody
        }
    }
    
    @ViewBuilder
    var noPathBody: some View {
        if #available(iOS 16.0, *) {
            SwiftUI.NavigationStack(root: content)
        } else {
            NavigationView(content: content)
                .navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder
    func pathBody(
        path: Binding<[Element]>,
        destination: @escaping (Element) -> Destination
    ) -> some View {
        if #available(iOS 16.0, *) {
            SwiftUI.NavigationStack(path: path) {
                content()
                    .navigationDestination(for: Element.self, destination: destination)
            }
        } else {
            NavigationView {
                NavigationStackChain(
                    path: path,
                    destination: destination,
                    index: 0,
                    inner: content
                )
            }
            .navigationViewStyle(.stack)
        }
    }
}

// MARK: - Legacy chain (iOS 15.x)

/// Recursive helper that renders one hidden `NavigationLink(isActive:)`
/// per path level. Activation is derived from `path.count > index`;
/// setting it false (e.g. user swipes back) truncates `path` to `index`,
/// which cascades any deeper level's activation to false too.
private struct NavigationStackChain<Element: Hashable, Destination: View, Inner: View>: View {
    @Binding var path: [Element]
    let destination: (Element) -> Destination
    let index: Int
    @ViewBuilder var inner: () -> Inner
    
    var body: some View {
        inner()
            .background(link)
    }
    
    private var link: some View {
        NavigationLink(isActive: isActiveBinding) {
            chainedDestination
        } label: {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var chainedDestination: some View {
        if index < path.count {
            NavigationStackChain<Element, Destination, Destination>(
                path: $path,
                destination: destination,
                index: index + 1,
                inner: { destination(path[index]) }
            )
        }
    }
    
    private var isActiveBinding: Binding<Bool> {
        Binding(
            get: { index < path.count },
            set: { active in
                if !active, index < path.count {
                    path = Array(path.prefix(index))
                }
            }
        )
    }
}
