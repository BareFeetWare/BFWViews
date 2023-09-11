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
        @State var isExpanded: Bool = true
        public let header: (any View)?
        public var cells: [Cell]
    }
}

public extension Plan.Section {

    init(
        id: String? = nil,
        isExpandable: Bool = false,
        isExpanded: Bool = true,
        header: (any View)?,
        cells: [Plan.Cell]
    ) {
        self.init(
            id: id ?? UUID().uuidString,
            isExpandable: isExpandable,
            isExpanded: isExpanded,
            header: header,
            cells: cells
        )
    }
    
    init(
        id: String? = nil,
        isExpandable: Bool = false,
        isExpanded: Bool = true,
        title: String? = nil,
        cells: [Plan.Cell]
    ) {
        self.init(
            id: id,
            isExpandable: isExpandable,
            isExpanded: isExpanded,
            header: title.map { Text($0) },
            cells: cells
        )
    }
    
}
