//
//  NavigationBackButtonTitle.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 5/11/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func navigationBackButtonTitle(_ title: String) -> some View {
        uiViewController { $0?.navigationItem.backButtonTitle = title }
    }
}
