//
//  Dispatch.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 21/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

public enum Dispatch<T> {
    case sync(T)
    case async(() async throws -> T)
}
