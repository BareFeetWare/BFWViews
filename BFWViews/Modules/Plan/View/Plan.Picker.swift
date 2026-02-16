//
//  Plan.Picker.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/2/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

extension Plan {
    public struct Picker {
        public let title: String
        @Binding public var selection: String
        public let options: [String]
        public let style: Style
        
        public init(
            _ title: String,
            selection: Binding<String>,
            options: [String],
            style: Style = .automatic
        ) {
            self.title = title
            self._selection = selection
            self.options = options
            self.style = style
        }
    }
}

// MARK: - Types

extension Plan.Picker {
    
    /// Storable representation of SwiftUI PickerStyle for use in view models.
    public enum Style {
        case automatic
        case menu
        case segmented
        case wheel
        case inline
        case navigationLink
    }

}

// MARK: - Views

extension Plan.Picker: View {
    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(option)
            }
        }
        .modifier(StyleModifier(style: style))
    }
    
    struct StyleModifier: ViewModifier {
        let style: Style
        
        @ViewBuilder
        func body(content: Content) -> some View {
            switch style {
            case .automatic:
                content.pickerStyle(.automatic)
            case .inline:
                content.pickerStyle(.inline)
            case .menu:
                content.pickerStyle(.menu)
            case .navigationLink:
                if #available(iOS 16, *) {
                    content.pickerStyle(.navigationLink)
                } else {
                    content.pickerStyle(.menu)
                }
            case .segmented:
                content.pickerStyle(.segmented)
            case .wheel:
                content.pickerStyle(.wheel)
            }
        }
    }
}

// MARK: - Previews

struct Plan_Picker_Previews: PreviewProvider {
    
    struct Preview: View {
        @State var selection: String = "Two"
        
        var body: some View {
            Plan.Picker(
                "Picker",
                selection: $selection,
                options: ["One", "Two"],
                style: .segmented
            )
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
