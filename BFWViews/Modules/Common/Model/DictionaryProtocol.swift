//
//  DictionaryProtocol.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 12/9/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

public protocol DictionaryProtocol {
    associatedtype Key: Hashable
    associatedtype Value

    subscript(key: Key) -> Value? { get set }
}

extension Dictionary: DictionaryProtocol {}
