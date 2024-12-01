//
//  Plan.Button.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

extension Plan {
    public struct Button {
        public let title: String
        public let role: ButtonRole?
        public let action: () -> Void
        
        public init(
            _ title: String,
            role: ButtonRole? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.role = role
            self.action = action
        }
    }
}
