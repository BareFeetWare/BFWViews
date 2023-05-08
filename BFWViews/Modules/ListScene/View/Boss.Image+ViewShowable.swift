//
//  Plan.Image+ViewShowable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Image: ViewShowable {
    public func view() -> AnyView {
        AnyView(
            AsyncImage(
                url: url
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        )
    }
}
