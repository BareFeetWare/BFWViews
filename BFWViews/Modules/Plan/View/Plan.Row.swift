//
//  Plan.Row.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    /// Simple concrete implementation of Plan.RowConstructor. Copy this to your app and add your own instances.
    public indirect enum Row: Plan.RowConstructor {
        public typealias Scene = Plan.Scene
        case button(Plan.Button)
        case detail(Plan.DetailRow)
        case navigationLink(Plan.NavigationLink<Self, Scene>)
        case optionalIdentified(OptionalIdentified<AnyView>)
        case picker(Plan.Picker)
    }
}

// MARK: - Views

extension Plan.Row: View {
    public var body: some View {
        switch self {
        case let .button(content): content
        case let .detail(content): content
        case let .navigationLink(content): content
        case let .optionalIdentified(content): content
        case let .picker(content): content
        }
    }
}

// MARK: - Previews

fileprivate struct Preview {
    @State var pickerSelection: String = "Option 1"
    
    var list: Plan.List<Plan.Row, Plan.Scene> {
        .init(
            rows: [
                .button("Button") {},
                .detail("Detail", subtitle: "Subtitle", trailing: "Trailing"),
                .navigationLink("navigationLink") {
                    .list(
                        rows: [
                            .detail("Row 1"),
                            .detail("Row 2"),
                        ]
                    )
                },
                .picker(
                    "Picker",
                    selection: $pickerSelection,
                    options: ["Option 1", "Option 2"]
                ),
            ]
        )
    }
}

extension Preview: View {
    var body: some View {
        list
            .navigationTitle("Plan.Row")
    }
}

#Preview {
    NavigationStack {
        Preview()
    }
}
