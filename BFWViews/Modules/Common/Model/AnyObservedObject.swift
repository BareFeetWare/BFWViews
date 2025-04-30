//
//  AnyObservedObject.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/4/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import Combine

/// Type erases multiple types of ObservableObjects, so they have the same type.
public class AnyObservableObject: ObservableObject {
    private let objectWillChangePublisher: AnyPublisher<Void, Never>

    public init<T: ObservableObject>(_ base: T) {
        self.objectWillChangePublisher = base.objectWillChange
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public var objectWillChange: AnyPublisher<Void, Never> {
        objectWillChangePublisher
    }
}

public protocol AnyObservable {
    var anyObservableObject: AnyObservableObject { get }
}

