//
//  OptionalProtocol.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 12/9/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

public protocol OptionalProtocol {
    associatedtype Wrapped
    var optional: Wrapped? { get set }
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    
    public var optional: Wrapped? {
        get { self }
        set { self = newValue }
    }
    
    public var isNil: Bool { self == nil }
}
