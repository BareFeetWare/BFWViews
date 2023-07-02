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
        public let isExpandable: Bool
        public let header: (any View)?
        public var cells: [Cell]
        @State var isExpanded: Bool = true
    }
}

public extension Plan.Section {

    init(
        id: String? = nil,
        isExpandable: Bool = false,
        header: (any View)?,
        cells: [Plan.Cell]
    ) {
        self.init(
            id: id ?? UUID().uuidString,
            isExpandable: isExpandable,
            header: header,
            cells: cells
        )
    }
    
    init(
        id: String? = nil,
        isExpandable: Bool = false,
        title: String? = nil,
        cells: [Plan.Cell]
    ) {
        self.init(
            id: id,
            isExpandable: isExpandable,
            header: title.map { Text($0) },
            cells: cells
        )
    }
    
}
