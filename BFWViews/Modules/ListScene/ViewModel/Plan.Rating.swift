//
//  Plan.Rating.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 16/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan {
    public struct Rating {
        public init(
            title: String? = nil,
            maximum: Int,
            selection: Binding<Int?>
        ) {
            self.title = title
            self.maximum = maximum
            self._selection = selection
        }
        
        public let title: String?
        public let maximum: Int
        @Binding public var selection: Int?
    }
}

// MARK: - Used by view

extension Plan.Rating {
    
    var selectionBinding: Binding<Int> {
        .init {
            selection ?? 0
        } set: {
            selection = $0
        }
    }
    
    func onTap(index: Int) {
        selection = index
    }

    func planImage(index: Int) -> Plan.Image {
        .system(
            symbol: .star,
            variants: index <= (selection ?? 0) ? .fill : .none,
            scale: .large
        )
    }
    
}
