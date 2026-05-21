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
        case anyView(AnyView)
        case button(Plan.Button)
        case detail(Plan.DetailRow)
        case labeledContent(Plan.LabeledContent<Self, Self>)
        case link(Plan.Link)
        case navigationLink(Plan.NavigationLink<Self, Scene>)
        case optionalIdentified(OptionalIdentified<Self>)
        case picker(Plan.Picker)
        case slider(Plan.Slider)
        case textField(Plan.TextField)
        case timelineView(Plan.TimelineView<Self>)
        case toggle(Plan.Toggle)
    }
}

// MARK: - Protocol Implementations

extension Plan.Row: OptionalIdentifiable {
    public var id: String? {
        switch self {
        case .anyView: nil
        case .button: nil
        case .detail(let detailRow): detailRow.id
        case .labeledContent(let labeledContent): labeledContent.label.id
        case .link: nil
        case .navigationLink(let navigationLink): navigationLink.label.id
        case .optionalIdentified(let optionalIdentified): optionalIdentified.id
        case .picker: nil
        case .slider(let slider): slider.detailRow.id
        case .textField: nil
        case .timelineView: nil
        case .toggle(let toggle): toggle.detailRow.id
        }
    }
}

extension Plan.Row: Matchable {
    public var matchStrings: [String] {
        switch self {
        case .anyView: []
        case .button(let button): [button.title]
        case .detail(let detail): detail.matchStrings
        case .labeledContent(let labeledContent): labeledContent.content.matchStrings + labeledContent.label.matchStrings
        case .link(let link): [link.title]
        case .navigationLink(let navigationLink): navigationLink.label.matchStrings
        case .optionalIdentified(let optionalIdentified): optionalIdentified.content.matchStrings
        case .picker: []
        case .slider(let slider): slider.detailRow.matchStrings
        case .textField(let textField): textField.detailRow.matchStrings + [textField.text]
        case .timelineView: []
        case .toggle(let toggle): toggle.detailRow.matchStrings
        }
    }
}

// MARK: - Views

extension Plan.Row: View {
    public var body: some View {
        switch self {
        case let .anyView(content): content
        case let .button(content): content
        case let .detail(content): content
        case let .labeledContent(content): content
        case let .link(content): content
        case let .navigationLink(content): content
        case let .optionalIdentified(content): content
        case let .picker(content): content
        case let .slider(content): content
        case let .textField(content): content
        case let .timelineView(content): content
        case let .toggle(content): content
        }
    }
}

// MARK: - Previews

fileprivate struct Preview {
    @State var textFieldText: String = ""
    @State var pickerSelection: String = "Option 1"
    @State var sliderValue: Int = 20
    @State var isOn: Bool = false
    
    var list: Plan.List<Plan.Row, Plan.Scene> {
        .init(
            rows: [
                .button("Button") {},
                .detail("Detail", subtitle: "Subtitle", trailing: "Trailing"),
                .labeledContent("Labeled Content", content: .textField("Text Field", text: $textFieldText)),
                .navigationLink("navigationLink") {
                    .list(
                        rows: [
                            .detail("Row 1"),
                            .detail("Row 2"),
                        ]
                    )
                },
                .optionalIdentified(.init(id: "123", content: .detail("Identified Row"))),
                .picker(
                    "Picker",
                    selection: $pickerSelection,
                    options: ["Option 1", "Option 2"]
                ),
                .slider(
                    "Slider",
                    trailing: "\(sliderValue)%",
                    value: $sliderValue,
                    in: 0 ... 100,
                    step: 5
                ),
                .secureField("Secure", text: $textFieldText),
                .textField("Text", text: $textFieldText),
                .toggle("Toggle", isOn: $isOn),
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
