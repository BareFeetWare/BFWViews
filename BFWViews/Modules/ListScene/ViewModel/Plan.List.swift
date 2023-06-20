//
//  Plan.List.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan {
    struct List {
        
        public init(
            sections: [Section]
        ) {
            self.sections = sections
        }
        
        public let sections: [Section]
    }
}

// MARK: - Convenience Inits

public extension Plan.List {
    
    init(
        cells: [Plan.Cell]
    ) {
        self.init(
            sections: [
                .init(cells: cells)
            ]
        )
    }
    
}

// MARK: - Previews

extension Plan.List {
    static let preview = Plan.List(
        sections: [
            .init(
                title: "Buttons and detail",
                cells: [
                    .button("Start") {},
                    .detail("Status", trailing: "Off line"),
                    .button("Scan") {},
                ]
            ),
            .init(
                title: "NavigationLink",
                cells: [
                    .detail("Children", trailing: "3") {
                        childrenScene
                    }
                ]
            ),
            .init(
                title: "Async children",
                cells: [
                    .detail("Children", trailing: "3") {
                        await asyncChildrenScene()
                    },
                ]
            ),
        ]
    )
    
    static func asyncChildrenScene() async -> some View {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        return childrenScene
    }
    
    static var childrenScene: some View {
        Plan.List(
            cells: [
                .detail("Child 1"),
                .detail("Child 2"),
                .detail("Child 3"),
            ]
        )
    }
    
}
