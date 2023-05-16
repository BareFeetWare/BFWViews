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
        public init(maximum: Int, selection: Int = 0) {
            self.maximum = maximum
            self.selection = selection
        }
        
        public let maximum: Int
        @State public var selection: Int
    }
}

extension Plan.Rating {
    static let preview: Self = .init(maximum: 5)
}
