//
//  ObservableObject+Binding.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/9/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension ObservableObject {
    
    /// Returns a `Binding` to a `@Published` property, using a reference-writable keyPath.
    func binding<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
    
}
