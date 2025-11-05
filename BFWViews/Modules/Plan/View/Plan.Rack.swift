//
//  Plan.Rack.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 3/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Rack {
        public let tabs: [Tab]
        @Binding public var selectedTabID: String
        @Binding public var isDisabledPicker: Bool
        
        public init(
            selectedTabID: Binding<String>,
            isDisabledPicker: Binding<Bool> = .constant(false),
            tabs: [Plan.Tab]
        ) {
            self._selectedTabID = selectedTabID
            self._isDisabledPicker = isDisabledPicker
            self.tabs = tabs
        }
    }
}

// MARK: - Views

extension Plan.Rack: View {
    public var body: some View {
        VStack {
            Picker("Tab", selection: $selectedTabID) {
                ForEach(tabs) { tab in
                    Text(tab.title)
                        .tag(tab.id)
                }
            }
            .pickerStyle(.segmented)
            .disabled(isDisabledPicker)
            .padding(.horizontal)
            // TODO: Keep state of tab (eg scroll) when switching.
            tabs.first { $0.id == selectedTabID }
            // Using TabView with style .page proved unreliable, where it sometimes failed to switch tabs when the selectedTabID changed.
        }
    }
}

// MARK: - Previews

extension Plan.Rack {
    
    static let preview: Self = {
        typealias List = Plan.List<Plan.Row, Never>
        let tabs: [Plan.Tab] = [
            .init(title: "First") {
                List(cells: [.detail("First")])
            },
            .init(title: "Second") {
                List(cells: [.detail("Second")])
            },
        ]
        return Plan.Rack(
            selectedTabID: .constant(tabs.first!.id),
            tabs: tabs
        )
    }()
    
}

struct PlanRack_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Rack.preview
    }
}
