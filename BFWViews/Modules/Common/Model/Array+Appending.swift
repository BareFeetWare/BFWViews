//
//  Array+Appending.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

internal extension Array {
    
    func appendingIfLet<T>(
        _ optional: T?,
        transform: (T) -> [Element]
    ) -> [Element] {
        guard let value = optional else { return self }
        return self + transform(value)
    }
    
}
