//
//  Observing.swift
//
//  Created by Tom Brodhurst-Hill on 19/6/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Wrap a view that needs to update when the `observed` object changes. Useful when injecting a view init into a view hierarchy.
public struct Observing<Content: View, Observed1: ObservableObject, Observed2: ObservableObject> {
    
    public init(
        _ observed1: Observed1,
        _ observed2: Observed2,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.observed1 = observed1
        self.observed2 = observed2
        self.content = content
    }
    
    @ObservedObject var observed1: Observed1
    @ObservedObject var observed2: Observed2
    @ViewBuilder let content: () -> Content
}

public extension Observing where Observed2 == EmptyObserved {
    
    init(
        _ observed1: Observed1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.observed1 = observed1
        self.observed2 = EmptyObserved()
        self.content = content
    }
}

extension Observing: View {
    public var body: some View {
        content()
    }
}

public class EmptyObserved: ObservableObject {}
