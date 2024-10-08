//
//  Plan.Button.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan {
    public struct Button {
        public let title: String
        public let action: () -> Void
        
        public init(
            _ title: String,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.action = action
        }
    }
}
