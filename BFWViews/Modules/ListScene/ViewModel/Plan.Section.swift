//
//  Plan.Section.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan {
    public struct Section: Identifiable {
        public let id: String
        public let header: (any View)?
        public var cells: [Cell]
    }
}

public extension Plan.Section {

    init(
        id: String? = nil,
        header: (any View)?,
        cells: [Plan.Cell]
    ) {
        self.id = id ?? UUID().uuidString
        self.header = header
        self.cells = cells
    }
    
    init(
        id: String? = nil,
        title: String? = nil,
        cells: [Plan.Cell]
    ) {
        self.init(
            id: UUID().uuidString,
            header: title.map { Text($0) },
            cells: cells
        )
    }
    
}
