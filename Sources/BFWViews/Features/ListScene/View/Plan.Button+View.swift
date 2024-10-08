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
        Button(title, action: action)
    }
}

struct Plan_Button_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Button("Button") {}
    }
}
