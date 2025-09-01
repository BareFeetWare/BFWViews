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
        public let isExpanded: Binding<Bool>?
        public let title: String?
        public let cells: [Cell?]
        public let emptyPlaceholder: String?
        
        public init(
            id: String = UUID().uuidString,
            isExpanded: Binding<Bool>? = nil,
            title: String? = nil,
            cells: [Cell?],
            emptyPlaceholder: String? = nil
        ) {
            self.id = id
            self.isExpanded = isExpanded
            self.title = title
            self.cells = cells
            self.emptyPlaceholder = emptyPlaceholder
        }
    }
}

public extension Plan.Section {
    
    var rowPlaceholderString: String? {
        guard let emptyPlaceholder, cells.isEmpty
        else { return nil }
        return emptyPlaceholder
    }
    
}
