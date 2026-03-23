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
/// Usage:
/// ```swift
/// TabView {
///     NavigationStackIfNeeded {
///         MyScene()
///     }
///     .tabItem { Label("My Tab", systemImage: "star") }
/// }
/// ```
public struct NavigationStackIfNeeded<Content: View> {
    @ViewBuilder let content: Content
    @State private var needsNavigationStack = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

// MARK: - Functions

private extension NavigationStackIfNeeded {
    
    func uiNavigationController(_ navigationController: UINavigationController?) {
        let needs = navigationController == nil
        // Guard against redundant writes, which would cause an infinite update loop.
        if needsNavigationStack != needs {
            needsNavigationStack = needs
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
                content
            }
        }
        .uiNavigationController(uiNavigationController)
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

