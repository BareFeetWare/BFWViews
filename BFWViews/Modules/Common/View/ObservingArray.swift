//
//  ObservingArray.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/4/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import Combine
import SwiftUI

/// Wrap a view that needs to update when the `combinedObserved` object changes. Useful when injecting a view init into a view hierarchy.
public struct ObservingArray<Content: View> {
    @StateObject private var combinedObserved: CombinedObserved
    @ViewBuilder let content: () -> Content
}

public extension ObservingArray {
    
    init(_ observables: AnyObservableObject..., @ViewBuilder content: @escaping () -> Content) {
        _combinedObserved = StateObject(wrappedValue: CombinedObserved(observables))
        self.content = content
    }
    
    init(_ observables: [AnyObservableObject], @ViewBuilder content: @escaping () -> Content) {
        _combinedObserved = StateObject(wrappedValue: CombinedObserved(observables))
        self.content = content
    }
    
}

private class CombinedObserved: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    init(_ objects: [AnyObservableObject]) {
        for object in objects {
            object.objectWillChange
                .sink { [weak self] in self?.objectWillChange.send() }
                .store(in: &cancellables)
        }
    }
}

// MARK: - Views

extension ObservingArray: View {
    public var body: some View {
        content()
    }
}
