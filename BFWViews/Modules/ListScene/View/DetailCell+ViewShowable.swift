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

// TODO: Move below out of ListScene. Move this to its own file.

extension ListScene.ViewModel.Button: ViewShowable {
    public func view() -> AnyView {
        AnyView(Button(title, action: action))
    }
}

extension ListScene.ViewModel.Image: ViewShowable {
    public func view() -> AnyView {
        AnyView(
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        )
    }
}
