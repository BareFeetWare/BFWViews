//
//  Collection+Empty.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

extension Collection {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}
