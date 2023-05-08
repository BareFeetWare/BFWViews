//
//  Plan.Button+Displayable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Button: Displayable {
    public func view() -> some View {
        Button(title, action: action)
    }
}
