//
//  Plan.DetailRow+ViewShowable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 27/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.DetailRow: ViewShowable {
    public func view() -> AnyView {
        AnyView(Display(viewModel: self))
    }
}
