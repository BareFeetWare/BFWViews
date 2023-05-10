//
//  Plan.ListScene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 10/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan {
    
    /// Convenience type containing a NavigationItem containing a List.
    public struct ListScene {
        public init(
            title: String?,
            sections: [Section],
            listStyle: Plan.List.Style = .automatic
        ) {
            self.navigationItem = .init(
                title: title,
                content: Plan.List(
                    sections: sections,
                    listStyle: listStyle
                )
            )
        }
        
        let navigationItem: Plan.NavigationItem
    }
}

extension Plan.ListScene {
    public init(
        title: String?,
        cells: [Plan.Cell],
        listStyle: Plan.List.Style = .automatic
    ) {
        self.init(
            title: title,
            sections: [.init(cells: cells)],
            listStyle: listStyle
        )
    }
}
