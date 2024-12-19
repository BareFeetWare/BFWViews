//
//  Plan.Button+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Button: View {
    public var body: some View {
        if let systemImage {
            Button(title, systemImage: systemImage, role: role, action: action)
        } else {
            Button(title, role: role, action: action)
        }
    }
}

// MARK: - Previews

struct Plan_Button_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Button("Button") {}
    }
}
