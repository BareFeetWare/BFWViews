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
    
    /// Only omit the id if the title is guaranteed to be unique.
    init(
        id: String? = nil,
        title: String,
        subtitle: String? = nil,
        trailing: String? = nil
    ) {
        self.id = id ?? title
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
    }
}
