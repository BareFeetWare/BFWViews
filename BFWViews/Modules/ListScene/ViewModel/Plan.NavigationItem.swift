//
//  Plan.NavigationItem.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 9/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
// TODO: Remove:
import SwiftUI

extension Plan {
    public struct NavigationItem {
        public let title: String?
        public let content: any View

        public init(title: String?, content: any View) {
            self.title = title
            self.content = content
        }
    }
}
