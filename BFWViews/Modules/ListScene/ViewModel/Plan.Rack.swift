//
//  Plan.Rack.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 3/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan {
    public struct Rack {
        
        public init(
            selectedTabID: Binding<String>,
            tabs: [Plan.Tab],
            isDisabledPicker: Bool = false
        ) {
            self._selectedTabID = selectedTabID
            self.tabs = tabs
            self.isDisabledPicker = isDisabledPicker
        }
        
        public let tabs: [Tab]
        @Binding public var selectedTabID: String
        public let isDisabledPicker: Bool
        
    }
}

extension Plan.Rack {
    
    static let preview: Self = {
        let tabs: [Plan.Tab] = [
            .init(title: "First", content: Plan.List(cells: [.detail("First")])),
            .init(title: "Second", content: Plan.List(cells: [.detail("Second")])),
        ]
        return Plan.Rack(selectedTabID: .constant(tabs.first!.id), tabs: tabs)
    }()
    
}
