//
//  Observing.swift
//
//  Created by Tom Brodhurst-Hill on 19/6/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Wrap a view that needs to update when the `observed` object changes. Useful when injecting a view init into a view hierarchy.
public struct Observing<
    Content: View,
    Observed1: ObservableObject,
    Observed2: ObservableObject,
    Observed3: ObservableObject
> {
    @StateObject var observed1: Observed1
    @StateObject var observed2: Observed2
    @StateObject var observed3: Observed3
    @ViewBuilder let content: () -> Content
}

// MARK: - Inits

public extension Observing where Observed2 == EmptyObserved, Observed3 == EmptyObserved {
    
    init(
        _ observed1: Observed1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._observed1 = StateObject(wrappedValue: observed1)
        self._observed2 = StateObject(wrappedValue: EmptyObserved())
        self._observed3 = StateObject(wrappedValue: EmptyObserved())
        self.content = content
    }
}

public extension Observing where Observed3 == EmptyObserved {
    
    init(
        _ observed1: Observed1,
        _ observed2: Observed2,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._observed1 = StateObject(wrappedValue: observed1)
        self._observed2 = StateObject(wrappedValue: observed2)
        self._observed3 = StateObject(wrappedValue: EmptyObserved())
        self.content = content
    }
}

public class EmptyObserved: ObservableObject {}

// MARK: - Views

extension Observing: View {
    public var body: some View {
        content()
    }
}
