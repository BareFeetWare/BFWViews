//
//  Plan.List+Mirror.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/10/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan.List {
    
    init?(reflecting subject: Any?) {
        guard let cells = [Plan.Cell](reflecting: subject)
        else { return nil }
        self.init(cells: cells)
    }
    
}
