//
//  Plan.List.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
// TODO: Remove:
import SwiftUI

public extension Plan {
    struct List {
        
        public init(
            title: String,
            sections: [Section],
            listStyle: Style = .automatic
        ) {
            self.title = title
            self.state = .init(sections: sections)
            self.listStyle = listStyle
        }
        
        public let title: String
        public let listStyle: Style
        @ObservedObject public var state: State
        
        public var sections: [Section] {
            get { state.sections }
            set { state.sections = newValue }
        }
    }
}

public extension Plan.List {
    class State: ObservableObject {
        
        init(sections: [Plan.Section]) {
            self.sections = sections
        }
        
        @Published var sections: [Plan.Section]
        @Published var isActiveDestination = false
        
        @Published public var destination: (any View)? {
            didSet {
                // TODO: Perhaps instead use subscriber.
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.isActiveDestination = self.destination != nil
                }
            }
        }
    }
}

// MARK: - Convenience Inits

public extension Plan.List {
    
    init(
        title: String,
        cells: [Plan.Cell]
    ) {
        self.init(
            title: title,
            sections: [
                .init(cells: cells)
            ]
        )
    }
    
}

// MARK: - Public Functions

public extension Plan.List {
    
    func action(
        destination: @escaping () async -> any View
    ) -> (() -> Void)? {
        {
            DispatchQueue.main.async {
                Task {
                    self.state.destination = await destination()
                }
            }
        }
    }
}

// MARK: - Previews

extension Plan.List {
    static let preview = Plan.List(
        title: "List Scene Root",
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
                title: "Async children",
                cells: [
                    .detail("Children", trailing: "3") {
                        Plan.List(title: "Children", cells: childrenCells)
                    },
                ]
            ),
        ]
    )
    
//    static func childrenSceneViewModel() async -> Plan.List {
//        // Arbitrary delay, pretending to be an async request.
//        try? await Task.sleep(nanoseconds: 2000000000)
//        return .init(
//            title: "Children",
//            cells: childrenCells
//        )
//    }
    
    static var childrenCells: [Plan.Cell] {
        ["Child 1", "Child 2", "Child 3"]
            .map { child in
                    .detail(child)
            }
    }
}
