//
//  NavigationStack.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 21/1/2026.
//

import SwiftUI

/// Backward compatibility implementation.
public struct NavigationStack<Content: View> {
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
}

extension NavigationStack: View {
    public var body: some View {
        if #available(iOS 16.0, *) {
            SwiftUI.NavigationStack(
                root: content
            )
        } else {
            NavigationView(
                content: content
            )
            .navigationViewStyle(.stack)
        }
    }
}
