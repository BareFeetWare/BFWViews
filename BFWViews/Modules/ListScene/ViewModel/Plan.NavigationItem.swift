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
        public let titleDisplayMode: NavigationBarItem.TitleDisplayMode
        public let content: any View

        public init(
            title: String?,
            titleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic,
            content: any View
        ) {
            self.title = title
            self.titleDisplayMode = titleDisplayMode
            self.content = content
        }
    }
}
