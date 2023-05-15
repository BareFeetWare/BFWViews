//
//  Plan+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Toggle: View {
    public var body: some View {
        Toggle(title, isOn: $isOn)
    }
}

extension Plan.Picker: View {
    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(options, id: \.self) { Text($0) }
        }
    }
}

extension Plan.Slider: View {
    public var body: some View {
        Slider(value: $selection, in: range)
    }
}

extension Plan.TextField: View {
    public var body: some View {
        TextField(title, text: $text)
            .textFieldStyle(.roundedBorder)
    }
}
