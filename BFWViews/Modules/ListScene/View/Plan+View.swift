//
//  Plan+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Frame: View {
    public var body: some View {
        AnyView(content.frame(width: width))
    }
}

extension Plan.HStack: View {
    
    private var anyViews: [AnyView] { contents.map { AnyView($0) }}
    
    public var body: some View {
        HStack {
            ForEach(0..<anyViews.count, id: \.self) { index in
                anyViews[index]
            }
        }
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

extension Plan.Text: View {
    public var body: some View {
        string.map { Text($0) }
    }
}

extension Plan.TextField: View {
    public var body: some View {
        TextField(title, text: $text)
            .textFieldStyle(.roundedBorder)
    }
}

extension Plan.Toggle: View {
    public var body: some View {
        Toggle(title, isOn: $isOn)
    }
}

extension Plan.VStack: View {
    
    private var anyViews: [AnyView] { contents.map { AnyView($0) }}
    
    public var body: some View {
        VStack(alignment: alignment) {
            ForEach(0..<anyViews.count, id: \.self) { index in
                anyViews[index]
            }
        }
    }
}
