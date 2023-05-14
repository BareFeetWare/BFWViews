//
//  Plan.Rack.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 3/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
// TODO: Remove:
import SwiftUI

extension Plan {
    public struct Rack {
        
        public init?(tabs: [Plan.Tab]) {
            guard let firstTab = tabs.first
            else { return nil }
            self.tabs = tabs
            _tab = State(initialValue: firstTab)
        }
        
        let tabs: [Tab]
        @State var tab: Tab
        
    }
}

extension Plan.Rack {
    static let preview = Plan.Rack(
        tabs: [
            .init(title: "First", content: Plan.List(cells: [.detail("First")])),
            .init(title: "Second", content: Plan.List(cells: [.detail("Second")])),
        ]
    )
}
