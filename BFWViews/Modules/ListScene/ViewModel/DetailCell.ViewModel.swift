//
//  DetailCell.ViewModel.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation

public extension DetailCell {
    struct ViewModel {
        let id: String
        let title: String?
        let subtitle: String?
        let trailing: String?
    }
}

public extension DetailCell.ViewModel {
    
    /// Use the title as the id. Only use this init if the titles are guaranteed to be unique.
    init(
        title: String,
        subtitle: String? = nil,
        trailing: String? = nil
    ) {
        self.id = title
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
    }
}
