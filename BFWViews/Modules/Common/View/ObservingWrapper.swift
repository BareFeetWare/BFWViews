//
//  ObservingWrapper.swift
//
//  Created by Tom Brodhurst-Hill on 19/6/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Wrap a view that needs to update when the `observed` object changes. Useful when injecting a view init into a view hierarchy.
public struct ObservingWrapper<Content: View, Observed: ObservableObject> {
    
    public init(observed: Observed, content: @escaping () -> Content) {
        self.observed = observed
        self.content = content
    }
    
    @ObservedObject var observed: Observed
    let content: () -> Content
}

extension ObservingWrapper: View {
    public var body: some View {
        content()
    }
}

// TODO: Perhaps change to use modifier, as below.

extension View {
    func observing<Observed: ObservableObject>(observed: Observed) -> some View {
        modifier(ObservingModifier(observed: observed))
    }
}

struct ObservingModifier<Observed: ObservableObject>: ViewModifier {
    
    @ObservedObject var observed: Observed
    
    func body(content: Content) -> some View {
        content
    }
}
