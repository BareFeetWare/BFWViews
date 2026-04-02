//
//  NavigationStackIfNeeded.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 23/3/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

/// Wraps content in a `NavigationStack` only when no `UINavigationController`
/// already exists in the view controller hierarchy.
///
/// This is useful for tabs in a `TabView` that may overflow into the
/// system-generated "More" tab on iPhone. The More tab provides its own
/// `UINavigationController`, so adding an explicit `NavigationStack` would
/// create a double navigation stack. `NavigationStackIfNeeded` detects the
/// existing controller and skips wrapping, so only one level of navigation
/// is ever present.
///
/// When no `NavigationStack` is provided, SwiftUI's `.navigationTitle` has no
/// effect. Use `.adaptiveNavigationTitle(_:)` instead, which sets both the
/// SwiftUI title and a preference that `NavigationStackIfNeeded` forwards to
/// UIKit's `navigationItem.title`.
///
/// Usage:
/// ```swift
/// TabView {
///     NavigationStackIfNeeded {
///         MyScene()
///             .adaptiveNavigationTitle("My Tab")
///     }
///     .tabItem { Label("My Tab", systemImage: "star") }
/// }
/// ```
public struct NavigationStackIfNeeded<Content: View> {
    @ViewBuilder let content: Content
    /// Defaults to `false`. Switched to `true` when the parent view controller
    /// is confirmed to have no ancestor `UINavigationController`.
    /// Starting at `false` avoids the SwiftUI bug where removing a
    /// `NavigationStack` via if/else branch switch leaves a ghost bar.
    @State private var needsNavigationStack = false
    /// Title captured from `adaptiveNavigationTitle`, forwarded to UIKit when
    /// no SwiftUI `NavigationStack` is present.
    @State private var externalTitle: String?

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

// MARK: - Functions

private extension NavigationStackIfNeeded {

    func onParentViewController(_ viewController: UIViewController?) {
        // Skip premature callbacks where the parent VC hasn't been
        // added to the hierarchy yet (parent is nil during initial
        // updateUIViewController). This prevents a false branch switch
        // that would destroy child @State.
        guard let viewController else { return }
        let needs = viewController.navigationController == nil
        if needsNavigationStack != needs {
            needsNavigationStack = needs
        }
        // When inside an external navigation controller (e.g. More tab),
        // forward the title captured via adaptiveNavigationTitle to UIKit's
        // navigationItem so UIMoreNavigationController displays it.
        if !needs, let externalTitle {
            if viewController.navigationItem.title != externalTitle {
                viewController.navigationItem.title = externalTitle
            }
        }
    }

}

// MARK: - Views

extension NavigationStackIfNeeded: View {
    public var body: some View {
        Group {
            if needsNavigationStack {
                NavigationStack {
                    content
                }
            } else {
                // VStack wrapper gives this branch a distinct structural
                // identity from the NavigationStack branch. Without it,
                // SwiftUI can fail to connect @State updates to the display
                // when the same `content` value appears in both branches.
                VStack(spacing: 0) {
                    content
                }
            }
        }
        .onPreferenceChange(NavigationTitlePreferenceKey.self) { title in
            externalTitle = title
        }
        .uiViewController(onParentViewController)
    }

}

// MARK: - Previews

#Preview("Without existing NavigationController") {
    NavigationStackIfNeeded {
        List {
            Text("This should have a navigation bar")
        }
        .navigationTitle("Standalone")
    }
}

#Preview("With existing NavigationController") {
    NavigationStack {
        NavigationStackIfNeeded {
            List {
                Text("This should not double the navigation bar")
            }
            .navigationTitle("Nested")
        }
    }
}

#Preview("TabView with More overflow") {
    TabView {
        NavigationStackIfNeeded {
            List {
                Text("First tab content")
            }
            .navigationTitle("First")
        }
        .tabItem { Label("First", systemImage: "1.circle") }
        NavigationStackIfNeeded {
            List {
                Text("Second tab content")
            }
            .navigationTitle("Second")
        }
        .tabItem { Label("Second", systemImage: "2.circle") }
        NavigationStackIfNeeded {
            List {
                Text("Third tab content")
            }
            .navigationTitle("Third")
        }
        .tabItem { Label("Third", systemImage: "3.circle") }
        NavigationStackIfNeeded {
            List {
                Text("Fourth tab content")
            }
            .navigationTitle("Fourth")
        }
        .tabItem { Label("Fourth", systemImage: "4.circle") }
        NavigationStackIfNeeded {
            List {
                NavigationLink("Push detail") {
                    Text("Detail view")
                        .navigationTitle("Detail")
                }
            }
            .navigationTitle("Fifth (overflow)")
        }
        .tabItem { Label("Fifth", systemImage: "5.circle") }
        NavigationStackIfNeeded {
            List {
                NavigationLink("Push detail") {
                    Text("Detail view")
                        .navigationTitle("Detail")
                }
            }
            .navigationTitle("Sixth (overflow)")
        }
        .tabItem { Label("Sixth", systemImage: "6.circle") }
    }
}
