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
        public let cells: [Plan.Cell?]
        public let emptyPlaceholder: String?
        
        public init(
            // Note: id must not use UUID() which prevents a refreshed section loading as the same instance.
            id: String,
            isExpanded: Binding<Bool>? = nil,
            title: String? = nil,
            cells: [Plan.Cell?],
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

// MARK: - Convenience Inits

public extension Plan.Section {
    
    /// Only omit id if title is unique/identifiable.
    init(
        isExpanded: Binding<Bool>? = nil,
        title: String,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
    ) {
        self.id = title
        self.isExpanded = isExpanded
        self.title = title
        self.cells = cells
        self.emptyPlaceholder = emptyPlaceholder
    }
    
}

// MARK: - Functions

public extension Plan.Section {
    
    var rowPlaceholderString: String? {
        guard let emptyPlaceholder, cells.isEmpty
        else { return nil }
        return emptyPlaceholder
    }
    
}
