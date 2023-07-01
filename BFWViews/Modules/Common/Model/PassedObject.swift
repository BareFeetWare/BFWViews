//
//  PassedObject.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/7/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

/// Observable class/object wrapper to pass/share between views.
public class PassedObject<Value>: ObservableObject {
    
    public init(value: Value) {
        self.value = value
    }
    
    @Published public var value: Value
}
