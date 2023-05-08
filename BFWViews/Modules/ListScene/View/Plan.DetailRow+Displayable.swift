//
//  Plan.DetailRow+Displayable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 27/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.DetailRow: Displayable {
    public func view() -> some View {
        Display(viewModel: self)
    }
}
