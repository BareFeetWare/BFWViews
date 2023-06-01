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
            TabView(selection: $selectedTabID) {
                ForEach(tabs) { tab in
                    tab
                        .tabItem {
                            Text(tab.title)
                        }
                        .tag(tab.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct PlanRack_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Rack.preview
    }
}
