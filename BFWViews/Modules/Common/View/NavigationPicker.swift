//
//  NavigationPicker.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/8/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

//  Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

// TODO: Consolidate with NavigationOptionalPicker

public struct NavigationPicker<Header: View, Option: Identifiable & View> {
    let title: String
    /// The navigationTitle should be less than 15 characters. If nil, then it uses the title.
    let navigationTitle: String?
    let selection: Binding<Option>
    let options: [Option]?
    let isSearchMatch: ((Option, String) -> Bool)?
    let header: () -> Header
    @State var isActive = false
    @State var searchString = ""
    
    public init(
        _ title: String,
        navigationTitle: String? = nil,
        selection: Binding<Option>,
        options: [Option],
        isSearchMatch: ((Option, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) {
        self.title = title
        self.navigationTitle = navigationTitle
        self.selection = selection
        self.options = options
        self.isSearchMatch = isSearchMatch
        self.header = header
    }
}

extension NavigationPicker where Option == IdentifiableText {
    
    public init(
        _ title: String,
        navigationTitle: String? = nil,
        selection: Binding<String>,
        options: [String]?,
        isSearchMatch: ((Option, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) {
        self.title = title
        self.navigationTitle = navigationTitle
        self.selection = selection.map { IdentifiableText($0) } reverse: { $0.title }
        self.options = options?.map { IdentifiableText($0) }
        self.isSearchMatch = isSearchMatch
        self.header = header
    }

}

extension NavigationPicker {
    
    public init<V: View & Identifiable>(
        _ title: String,
        navigationTitle: String? = nil,
        selection: Binding<V?>,
        options: [V],
        isSearchMatch: ((V, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) where Option == OptionalRow<V> {
        self.title = title
        self.navigationTitle = navigationTitle
        self.selection = selection.map { option in
            OptionalRow(content: option)
        } reverse: { optionalRow in
            optionalRow.content
        }
        self.options = options.map { OptionalRow(content: $0) }
        self.isSearchMatch = isSearchMatch.map { isSearchMatch in
            { option, searchString in
                guard let content = option.content else { return true }
                return isSearchMatch(content, searchString)
            }
        }
        self.header = header
    }
    
}

extension NavigationPicker {
    
    var displayedOptions: [Option]? {
        guard let isSearchMatch, !searchString.isEmpty
        else { return options }
        return options?.filter { option in
            isSearchMatch(option, searchString)
        }
    }
    
    var preferredNavigationTitle: String {
        navigationTitle ?? title
    }
}

private struct TickRow<Option: View & Identifiable> {
    @Binding var selection: Option
    let option: Option
    @Environment(\.dismiss) var dismiss
    
    var id: Option.ID {
        option.id
    }
    
    func onTap(option: Option) {
        selection = option
        dismiss()
    }
}

// MARK: - Views

extension NavigationPicker: View {
    public var body: some View {
        if let displayedOptions {
            NavigationLink(isActive: $isActive) {
                Form {
                    Section {
                        ForEach(displayedOptions) { option in
                            tickRow(option: option)
                        }
                    } header: {
                        header()
                    }
                }
                .searchable(text: $searchString)
                .navigationTitle(preferredNavigationTitle)
            } label: {
                HStack {
                    Text(title)
                    Spacer()
                    selection.wrappedValue
                }
            }
        } else {
            HStack {
                Text(title)
                Spacer()
                ProgressView()
            }
        }
    }
    
    func tickRow(option: Option) -> some View {
        TickRow(selection: selection, option: option)
    }
    
}

extension TickRow: View {
    var body: some View {
        Button {
            onTap(option: option)
        } label: {
            HStack {
                option
                Spacer()
                if option.id == selection.id {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
            // Note: .contentShape(Rectangle()) is required to extend the tappable area across the whole cell width.
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

struct NavigationPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        Preview()
        StringPreview()
    }
    
    struct Preview: View {
        @State var selection: Fruit = .apple
        @State var opitonalSelection: Fruit?
        let fruits: [Fruit] = [.apple, .banana, .orange]
        
        enum Fruit: Identifiable & View {
            case apple, banana, orange
            
            var id: String { name }
            
            var name: String {
                String(describing: self)
            }
            
            var emoji: String {
                switch self {
                case .apple: "🍎"
                case .banana: "🍌"
                case .orange: "🍊"
                }
            }
            
            var body: some View {
                HStack {
                    Text(emoji)
                    Text(name)
                }
            }
        }
        
        var body: some View {
            NavigationView {
                Form {
                    NavigationPicker(
                        "Favorite Fruit",
                        navigationTitle: "Fruit",
                        selection: $selection,
                        options: fruits
                    ) { fruit, searchString in
                        fruit.name.matchesSearch(searchString)
                        || fruit.emoji.matchesSearch(searchString)
                    } header: {
                        Text("Choose your favorite fruit")
                            .textCase(.none)
                    }
                    NavigationPicker(
                        "Optional Fruit",
                        selection: $opitonalSelection,
                        options: fruits
                    ) { fruit, searchString in
                        fruit.name.matchesSearch(searchString)
                        || fruit.emoji.matchesSearch(searchString)
                    }
                }
                .navigationTitle("View Picker")
            }
        }
    }
    
    struct StringPreview: View {
        @State var selection: String = "apple"
        let fruits: [String] = ["apple", "banana", "orange"]
        
        var body: some View {
            NavigationView {
                Form {
                    NavigationPicker(
                        "Fruit",
                        selection: $selection,
                        options: fruits,
                        isSearchMatch: { $0.title.matchesSearch($1) }
                    )
                }
                .navigationTitle("Text Picker")
            }
        }
    }
    
}

private extension String {
    func matchesSearch(_ search: String) -> Bool {
        localizedCaseInsensitiveContains(search)
    }
}
