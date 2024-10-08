//
//  Plan.Rack+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 3/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

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

struct PlanRack_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Rack.preview
    }
}
