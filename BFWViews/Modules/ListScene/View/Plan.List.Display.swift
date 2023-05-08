//
//  Plan.List.Display.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan.List {
    struct Display {
        @ObservedObject var viewModel: Plan.List
        
        public init(viewModel: Plan.List) {
            self.viewModel = viewModel
        }
    }
}
