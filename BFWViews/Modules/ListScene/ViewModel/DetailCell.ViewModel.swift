//
//  DetailCell.ViewModel.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation

public extension DetailCell {
    struct ViewModel {
        public let id: String
        public let title: String?
        public let subtitle: String?
        public let trailing: String?
    }
}

public extension DetailCell.ViewModel {
    init(
        id: String? = nil,
        title: String,
        subtitle: String? = nil,
        trailing: String? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
    }
}
