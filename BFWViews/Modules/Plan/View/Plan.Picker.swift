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
    /// A view-model picker. The struct stays concrete (no generics, no stored view) by
    /// erasing identifiers to `AnyHashable`; the generic boundary is the init only, so
    /// callers can pick any `Identifiable` while `Scheme.Row.picker` carries one type.
    public struct Picker {
        public let title: String
        @Binding public var selection: AnyHashable?
        public let options: [Option]
        public let style: Style
        
        /// Pick any `Identifiable` from `options`, shown via `label`, bound by `id`.
        /// `subtitle` is an optional per-option caption shown under the label —
        /// mainly useful in `.inline` style (the only built-in `PickerStyle` whose
        /// rows are tall enough to show a second line).
        public init<Item: Identifiable>(
            _ title: String,
            selection: Binding<Item.ID?>,
            options: [Item],
            label: (Item) -> String,
            subtitle: ((Item) -> String?)? = nil,
            style: Style = .automatic
        ) {
            self.title = title
            self._selection = Binding(
                get: { selection.wrappedValue.map(AnyHashable.init) },
                set: { selection.wrappedValue = $0?.base as? Item.ID }
            )
            self.options = options.map {
                Option(
                    id: AnyHashable($0.id),
                    label: label($0),
                    subtitle: subtitle?($0)
                )
            }
            self.style = style
        }
    }
}

// MARK: - Convenience Inits

public extension Plan.Picker {
    
    /// Convenience for the common case where the options are plain strings and the
    /// selection is one of them (label == value).
    init(
        _ title: String,
        selection: Binding<String>,
        options: [String],
        style: Style = .automatic
    ) {
        self.title = title
        self._selection = Binding(
            get: { selection.wrappedValue as AnyHashable? },
            set: { selection.wrappedValue = $0?.base as? String ?? "" }
        )
        self.options = options.map { Option(id: AnyHashable($0), label: $0, subtitle: nil) }
        self.style = style
    }

}

// MARK: - Types

extension Plan.Picker {
    
    public struct Option: Identifiable {
        public let id: AnyHashable
        public let label: String
        public let subtitle: String?
    }
    
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
            ForEach(options) { option in
                if let subtitle = option.subtitle {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(option.label)
                        Text(subtitle)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .tag(Optional(option.id))
                } else {
                    Text(option.label)
                        .tag(Optional(option.id))
                }
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
                // Hidden label keeps the VoiceOver name without duplicating a
                // section header in the inline list.
                content.pickerStyle(.inline).labelsHidden()
            case .menu:
                content.pickerStyle(.menu)
            case .navigationLink:
                if #available(iOS 16, *) {
                    content.pickerStyle(.navigationLink)
                } else {
                    content.pickerStyle(.menu)
                }
            case .segmented:
                // Hidden label keeps the VoiceOver name without duplicating a
                // section header beside the segmented control.
                content.pickerStyle(.segmented).labelsHidden()
            case .wheel:
                content.pickerStyle(.wheel)
            }
        }
    }
}

// MARK: - Previews

struct Plan_Picker_Previews: PreviewProvider {
    
    struct StringPreview: View {
        @State var selection: String = "Two"
        
        var body: some View {
            Form {
                Plan.Picker(
                    "Number",
                    selection: $selection,
                    options: ["One", "Two"],
                    style: .segmented
                )
            }
        }
    }
    
    struct IdentifiedPreview: View {
        struct Fruit: Identifiable {
            let id: String
            let emoji: String
        }
        
        let fruits = [
            Fruit(id: "apple", emoji: "🍎"),
            Fruit(id: "banana", emoji: "🍌"),
            Fruit(id: "orange", emoji: "🍊"),
        ]
        
        @State var selection: String?
        
        var body: some View {
            Form {
                Plan.Picker(
                    "Fruit",
                    selection: $selection,
                    options: fruits,
                    label: { "\($0.emoji) \($0.id.capitalized)" },
                    style: .inline
                )
            }
        }
    }
    
    static var previews: some View {
        StringPreview()
        IdentifiedPreview()
    }
}
