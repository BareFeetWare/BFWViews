//
//  Plan.Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan {
    struct Image: Identifiable {
        public var id: String = UUID().uuidString
        public let url: URL
    }
}
