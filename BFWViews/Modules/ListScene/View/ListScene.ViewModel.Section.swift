//
//  ListScene.ViewModel.Section.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

extension ListScene.ViewModel {
    public struct Section: Identifiable {
        public let id: String
        public let title: String?
        public var cells: [Cell]
    }
}

public extension ListScene.ViewModel.Section {
    
    init(
        title: String? = nil,
        cells: [ListScene.ViewModel.Cell]
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.cells = cells
    }
    
}
