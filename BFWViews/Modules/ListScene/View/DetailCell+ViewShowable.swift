//
//  DetailCell+ViewShowable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 27/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension DetailCell.ViewModel: ViewShowable {
    public func view() -> AnyView {
        AnyView(DetailCell(viewModel: self))
    }
}
