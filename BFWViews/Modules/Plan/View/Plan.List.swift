//
//  Plan.List.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan {
    struct List<Cell: View> {
        public let isSearchable: Bool
        public let selection: Binding<String?>?
        let sections: [Plan.Section<Cell>]
        @State var searchString: String = ""
        
        public init(
            isSearchable: Bool = false,
            selection: Binding<String?>? = nil,
            sections: [Plan.Section<Cell>]
        ) {
            self.isSearchable = isSearchable
            self.selection = selection
            self.sections = sections
        }
        
    }
}

// MARK: - Convenience Inits

public extension Plan.List {
    
    init(
        isSearchable: Bool = false,
        selection: Binding<String?>,
        sections: [Plan.Section<Cell>]
    ) {
        self.isSearchable = isSearchable
        self.selection = selection
        self.sections = sections
    }
    
    init(
        isSearchable: Bool = false,
        selection: Binding<String?>,
        cells: [Cell]
    ) {
        self.init(
            isSearchable: isSearchable,
            selection: selection,
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", cells: cells)
            ]
        )
    }
    
    init(
        isSearchable: Bool = false,
        sections: [Plan.Section<Cell>]
    ) {
        self.isSearchable = isSearchable
        self.selection = nil
        self.sections = sections
    }
    
    init(
        isSearchable: Bool = false,
        cells: [Cell]
    ) {
        self.init(
            isSearchable: isSearchable,
            sections: [
                // Note: The id is needed here so it consistently has the same id for this section, otherwise animations will not track it correctly, such as in an expanding/collapsing DisclosureGroup.
                .init(id: "only one section", cells: cells)
            ]
        )
    }
    
}

// MARK: - Functions

extension Plan.List {
    
    var sectionsIdentified: [Identified<Plan.Section<Cell>>] {
        sections.identified()
    }
}

// MARK: - Views

extension Plan.List: View {
    public var body: some View {
        List(selection: selection) {
            ForEach(sectionsIdentified) { $0 }
        }
        .if(isSearchable) {
            $0.searchable(text: $searchString)
        }
    }
}

// MARK: - Previews

struct PlanListDisplay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Preview()
        }
    }
}

private struct Preview {
    @State var selectedCellID: String?
    typealias List = Plan.Simple.List
    typealias Scene = Plan.Simple.Scene
}

extension Preview {
    
    var list: List {
        .init(
            selection: $selectedCellID,
            sections: [
                .init(
                    title: "selection",
                    cells: [
                        .detail("selection:", trailing: selectedCellID),
                    ]
                ),
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
                        .push("Children", trailing: "3") {
                            childrenScene
                        }
                    ]
                ),
                .init(
                    title: "Async children",
                    cells: [
                        .push("Children", trailing: "3") {
                            try await asyncChildrenScene()
                        },
                    ]
                ),
            ]
        )
    }
    
    func asyncChildrenScene() async throws -> Scene {
        // Arbitrary delay, pretending to be an async request.
        try await Task.sleep(nanoseconds: 2000000000)
        return childrenScene
    }
    
    var childrenScene: Scene {
        .list(
            cells: [
                .detail("Child 1"),
                .detail("Child 2"),
                .detail("Child 3"),
            ]
        )
    }
    
}

extension Preview: View {
    var body: some View {
        list
            .navigationBarTitle("Plan.List")
    }
}
