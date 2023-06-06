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
            sections: [Section],
            listStyle: Style = .automatic
        ) {
            self.sections = sections
            self.listStyle = listStyle
        }
        
        public let listStyle: Style
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
                    .init(
                        id: "Children",
                        content: NavigationLink(
                            destination: {
                                childrenScene
                            },
                            label: {
                                Plan.DetailRow(title: "Children", trailing: "3")
                            }
                        )
                    )
                ]
            ),
            .init(
                title: "Async children",
                cells: [
                    .init(
                        id: "Children",
                        content: AsyncNavigationLink {
                            await childrenScene()
                        } label: {
                            Plan.DetailRow(title: "Children", trailing: "3")
                        }
                    ),
                ]
            ),
        ]
    )
    
    static func childrenScene() async -> some View {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        return childrenScene
    }
    
    static var childrenScene: some View {
        Plan.ListScene(
            title: "Children",
            cells: [
                .detail("Child 1"),
                .detail("Child 2"),
                .detail("Child 3"),
            ]
        )
    }
    
}
