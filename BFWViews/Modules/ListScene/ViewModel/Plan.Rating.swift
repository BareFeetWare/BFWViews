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
            selection: Binding<Int>
        ) {
            self.title = title
            self.maximum = maximum
            self._selection = selection
        }
        
        public let title: String?
        public let maximum: Int
        @Binding public var selection: Int
    }
}

// MARK: - Used by view

extension Plan.Rating {
    
    func onTap(index: Int) {
        // FIXME: UI isn't updating, but binding is.
        selection = index
    }
    
    func symbol(index: Int) -> ImageSymbol {
        index <= selection ? .starFill : .star
    }
}

// MARK: - Preview

extension Plan.Rating {
    
    private struct Preview {
        @State static var selection: Int = 0
    }
    
    static let preview: Self = .init(
        title: "Rating",
        maximum: 5,
        selection: Preview.$selection
    )
}
