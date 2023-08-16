//
//  Observing.swift
//
//  Created by Tom Brodhurst-Hill on 19/6/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Wrap a view that needs to update when the `observed` object changes. Useful when injecting a view init into a view hierarchy.
public struct Observing<Content: View, Observed: ObservableObject> {
    
    public init(
        _ observed: Observed,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.observed = observed
        self.content = content
    }
    
    @ObservedObject var observed: Observed
    @ViewBuilder let content: () -> Content
}

extension Observing: View {
    public var body: some View {
        content()
    }
}
