//
//  Array+Appending.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

/// Internal, not public: BFWFetch vends the same helpers publicly, and identical overloads visible from two modules make call-site inference ambiguous.
extension Array {
    
    func appendingIf(
        _ condition: Bool,
        elements: () -> [Element]
    ) -> [Element] {
        condition ? self + elements() : self
    }
    
    func appendingIfLet<T>(
        _ optional: T?,
        transform: (T) -> [Element]
    ) -> [Element] {
        guard let value = optional else { return self }
        return self + transform(value)
    }
    
}
