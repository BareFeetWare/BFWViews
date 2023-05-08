//
//  Plan.Button.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan {
    public struct Button: Identifiable {
        public let id: String
        public let title: String
        public let action: () -> Void
        
        public init(
            id: String? = nil,
            title: String,
            action: @escaping () -> Void
        ) {
            self.id = id ?? UUID().uuidString
            self.title = title
            self.action = action
        }
    }
}
