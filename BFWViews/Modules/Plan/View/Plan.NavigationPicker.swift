//
//  Plan.NavigationPicker.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 16/6/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

extension Plan {
    /// A view-model wrapper around `NavigationPicker`. The struct stays concrete (no generics, no stored view) by erasing identifiers to `AnyHashable`; the generic boundary is the init only, so callers can pick any `Identifiable` while `Scheme.Row.navigationPicker` carries one type. Mirrors the `Plan.Picker` pattern.
    public struct NavigationPicker {
        public let title: String
        @Binding public var selection: AnyHashable?
        public let options: [Option]
        public let noneString: String
        public let isSearchMatch: ((Option, String) -> Bool)?
        
        /// Pick any `Identifiable` from `options`, shown via `label`. When the selection
        /// is `nil`, `noneString` is shown as the placeholder. `isSearchMatch` filters
        /// the option list as the operator types.
        public init<Item: Identifiable>(
            _ title: String,
            selection: Binding<Item.ID?>,
            options: [Item],
            label: (Item) -> String,
            noneString: String = "",
            isSearchMatch: ((Item, String) -> Bool)? = nil
        ) {
            self.title = title
            self._selection = Binding(
                get: { selection.wrappedValue.map(AnyHashable.init) },
                set: { selection.wrappedValue = $0?.base as? Item.ID }
            )
            let items = options
            self.options = items.enumerated().map { index, item in
                Option(id: AnyHashable(item.id), label: label(item), index: index)
            }
            self.noneString = noneString
            self.isSearchMatch = isSearchMatch.map { match in
                { option, query in match(items[option.index], query) }
            }
        }
    }
}

// MARK: - Types

extension Plan.NavigationPicker {
    
    public struct Option: Identifiable, View {
        public let id: AnyHashable
        public let label: String
        let index: Int
        
        public var body: some View {
            Text(label)
        }
    }
    
}

// MARK: - Views

extension Plan.NavigationPicker: View {
    public var body: some View {
        NavigationPicker(
            title,
            selection: optionSelection,
            options: options,
            noneString: noneString,
            isSearchMatch: isSearchMatch
        )
    }
}

private extension Plan.NavigationPicker {
    
    var optionSelection: Binding<Option?> {
        Binding(
            get: { options.first(where: { $0.id == selection }) },
            set: { selection = $0?.id }
        )
    }
    
}

// MARK: - Previews

struct Plan_NavigationPicker_Previews: PreviewProvider {
    
    struct IdentifiedPreview: View {
        struct Fruit: Identifiable {
            let id: String
            let name: String
        }
        
        let fruits = [
            Fruit(id: "apple", name: "Apple"),
            Fruit(id: "banana", name: "Banana"),
            Fruit(id: "orange", name: "Orange"),
        ]
        
        @State var selection: String?
        
        var body: some View {
            NavigationStack {
                Form {
                    Plan.NavigationPicker(
                        "Fruit",
                        selection: $selection,
                        options: fruits,
                        label: \.name,
                        noneString: "Required",
                        isSearchMatch: { fruit, search in
                            fruit.name.localizedCaseInsensitiveContains(search)
                        }
                    )
                }
            }
        }
    }
    
    static var previews: some View {
        IdentifiedPreview()
    }
}
