//
//  DetailCell+ViewShowable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 27/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension DetailCell.ViewModel: ViewShowable {
    public func view() -> any View {
        DetailCell(viewModel: self)
    }
}

// TODO: Move Button out of ListScene. Move this to its own file.

extension ListScene.ViewModel.Button: ViewShowable {
    public func view() -> any View {
        Button(title, action: action)
    }
}
