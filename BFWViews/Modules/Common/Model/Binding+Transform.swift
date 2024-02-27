//
//  Binding+Transform.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 23/1/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

public protocol OptionalProtocol {
    associatedtype Wrapped
    var optional: Wrapped? { get set }
}

extension Optional: OptionalProtocol {
    public var optional: Wrapped? {
        get {
            self
        }
        set {
            self = newValue
        }
    }
}

public extension Binding where Value: OptionalProtocol {

    var isNotNil: Binding<Bool> {
        .init {
            wrappedValue.optional != nil
        } set: {
            if !$0 {
                wrappedValue.optional = nil
            }
        }
    }
    
}

public extension Binding {
    func map<Transform>(
        transform: @escaping (Value) -> Transform,
        reverse: @escaping (Transform) -> Value
    ) -> Binding<Transform> {
        .init(
            get: { transform(wrappedValue) },
            set: { wrappedValue = reverse($0) }
        )
    }
}

public extension Binding where Value == Bool {
    func toggled() -> Binding<Bool> {
        map { !$0 } reverse: { !$0 }
    }
}
