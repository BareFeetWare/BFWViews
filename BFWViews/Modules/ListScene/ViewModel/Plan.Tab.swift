//
//  Plan.Tab.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 9/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
// TODO: Remove:
import SwiftUI

extension Plan {
    public struct Tab {
        
        public init(
            title: String,
            content: any View
        ) {
            self.title = title
            self.content = content
        }
        
        public let title: String
        public let content: any View
    }
}

extension Plan.Tab: Identifiable {
    public var id: String { title }
}

extension Plan.Tab: Hashable {
    
    public static func == (lhs: Plan.Tab, rhs: Plan.Tab) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
