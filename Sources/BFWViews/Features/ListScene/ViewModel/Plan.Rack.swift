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
            isDisabledPicker: Binding<Bool> = .constant(false),
            tabs: [Plan.Tab]
        ) {
            self._selectedTabID = selectedTabID
            self._isDisabledPicker = isDisabledPicker
            self.tabs = tabs
        }
        
        public let tabs: [Tab]
        @Binding public var selectedTabID: String
        @Binding public var isDisabledPicker: Bool
        
    }
}

extension Plan.Rack {
    
    static let preview: Self = {
        let tabs: [Plan.Tab] = [
            .init(title: "First") {
                Plan.List(cells: [.detail("First")])
            },
            .init(title: "Second") {
                Plan.List(cells: [.detail("Second")])
            },
        ]
        return Plan.Rack(
            selectedTabID: .constant(tabs.first!.id),
            tabs: tabs
        )
    }()
    
}
