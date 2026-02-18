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
        case labeledContent(Plan.LabeledContent<Self, Self>)
        case navigationLink(Plan.NavigationLink<Self, Scene>)
        case optionalIdentified(OptionalIdentified<Self>)
        case picker(Plan.Picker)
        case textField(Plan.TextField)
    }
}

// MARK: - Protocol Implementations

extension Plan.Row: OptionalIdentifiable {
    public var id: String? {
        switch self {
        case .detail(let detailRow): detailRow.id
        case .navigationLink(let navigationLink): navigationLink.label.id
        case .optionalIdentified(let optionalIdentified): optionalIdentified.id
        default: nil
        }
    }
}

extension Plan.Row: Matchable {
    public var matchStrings: [String] {
        switch self {
        case .button(let button): [button.title]
        case .detail(let detail): detail.matchStrings
        case .labeledContent(let labeledContent): labeledContent.content.matchStrings + labeledContent.label.matchStrings
        case .navigationLink(let navigationLink): navigationLink.label.matchStrings
        case .optionalIdentified(let optionalIdentified): optionalIdentified.content.matchStrings
        case .picker: []
        case .textField(let textField): [textField.title, textField.text]
        }
    }
}

// MARK: - Views

extension Plan.Row: View {
    public var body: some View {
        switch self {
        case let .button(content): content
        case let .detail(content): content
        case let .labeledContent(content): content
        case let .navigationLink(content): content
        case let .optionalIdentified(content): content
        case let .picker(content): content
        case let .textField(content): content
        }
    }
}

// MARK: - Previews

fileprivate struct Preview {
    @State var textFieldText: String = ""
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
                .labeledContent("Labeled Content", content: .textField("Text Field", text: $textFieldText)),
                .optionalIdentified(.init(id: "123", content: .detail("Identified Row"))),
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
