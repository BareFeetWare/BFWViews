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

public struct NavigationPicker<Label: View, Header: View, Option: Identifiable & View> {
    let label: () -> Label
    /// The navigationTitle should be less than 15 characters. If nil, then it uses the label.
    let navigationTitle: String?
    let selection: Binding<Option>
    let options: [Option]?
    let isSearchMatch: ((Option, String) -> Bool)?
    let header: () -> Header
    @State var isActive = false
    @State var searchString = ""
    
    public init(
        navigationTitle: String? = nil,
        selection: Binding<Option>,
        options: [Option],
        label: @escaping () -> Label,
        isSearchMatch: ((Option, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) {
        self.navigationTitle = navigationTitle
        self.selection = selection
        self.options = options
        self.label = label
        self.isSearchMatch = isSearchMatch
        self.header = header
    }
}

// MARK: - Types

private struct TickRow<Option: View & Identifiable> {
    @Binding var selection: Option
    let option: Option
    @Environment(\.dismiss) var dismiss
}

// MARK: - Convenience Inits

extension NavigationPicker where Label == Text {
    
    public init(
        _ title: String,
        navigationTitle: String? = nil,
        selection: Binding<Option>,
        options: [Option],
        isSearchMatch: ((Option, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) {
        self.navigationTitle = navigationTitle
        self.selection = selection
        self.options = options
        self.label = { Text(title) }
        self.isSearchMatch = isSearchMatch
        self.header = header
    }
    
}

extension NavigationPicker where Label == Text, Option == IdentifiableText {
    
    public init(
        _ title: String,
        navigationTitle: String? = nil,
        selection: Binding<String>,
        options: [String]?,
        isSearchMatch: ((Option, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) {
        self.navigationTitle = navigationTitle
        self.selection = selection.map { IdentifiableText($0) } reverse: { $0.title }
        self.options = options?.map { IdentifiableText($0) }
        self.label = { Text(title) }
        self.isSearchMatch = isSearchMatch
        self.header = header
    }
    
}

extension NavigationPicker {
    
    public init<V: View & Identifiable>(
        navigationTitle: String? = nil,
        selection: Binding<V?>,
        options: [V],
        noneString: String,
        label: @escaping () -> Label,
        isSearchMatch: ((V, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) where Option == OptionalRow<V> {
        self.navigationTitle = navigationTitle
        self.selection = selection.map { option in
            OptionalRow(noneString: noneString, content: option)
        } reverse: { optionalRow in
            optionalRow.content
        }
        self.options = options.map {
            OptionalRow(noneString: noneString, content: $0)
        }
        self.label = label
        self.isSearchMatch = isSearchMatch.map { isSearchMatch in
            { option, searchString in
                guard let content = option.content else { return true }
                return isSearchMatch(content, searchString)
            }
        }
        self.header = header
    }
    
    public init<V: View & Identifiable>(
        _ title: String,
        navigationTitle: String? = nil,
        selection: Binding<V?>,
        options: [V],
        noneString: String,
        isSearchMatch: ((V, String) -> Bool)? = nil,
        header: @escaping (() -> Header) = { EmptyView() }
    ) where Option == OptionalRow<V>, Label == Text {
        self.init(
            navigationTitle: navigationTitle,
            selection: selection,
            options: options,
            noneString: noneString,
            label: { Text(title) },
            isSearchMatch: isSearchMatch,
            header: header
        )
    }
    
}

// MARK: - Functions

extension NavigationPicker {
    
    var displayedOptions: [Option]? {
        guard let isSearchMatch, !searchString.isEmpty
        else { return options }
        return options?.filter { option in
            isSearchMatch(option, searchString)
        }
    }
    
}

extension TickRow {
    
    var id: Option.ID {
        option.id
    }
    
    func onTap(option: Option) {
        selection = option
        dismiss()
    }
    
    var isHidden: Bool {
        option.id != selection.id
    }
    
}

// MARK: - Private Extensions

private extension String {
    func matchesSearch(_ search: String) -> Bool {
        localizedCaseInsensitiveContains(search)
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
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        navigationBarContent
                    }
                }
            } label: {
                HStack {
                    label()
                    Spacer()
                    selection.wrappedValue
                }
            }
        } else {
            HStack {
                label()
                Spacer()
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    var navigationBarContent: some View {
        if let navigationTitle {
            Text(navigationTitle)
        } else {
            label()
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
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
                    .if(isHidden) { $0.hidden() }
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
        @State var optionalSelection: Fruit?
        let fruits: [Fruit] = [.apple, .banana, .orange]
        let noneString = "None"
        
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
                    Section("NavigationPicker") {
                        NavigationPicker(
                            "Fruit Title",
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
                            selection: $optionalSelection,
                            options: fruits,
                            noneString: noneString
                        ) {
                            Text("Favorite Fruit")
                        } isSearchMatch: { fruit, searchString in
                            fruit.name.matchesSearch(searchString)
                            || fruit.emoji.matchesSearch(searchString)
                        }
                    }
                    Section("SwiftUI Picker (for comparison)") {
                        Picker(selection: $selection) {
                            ForEach(fruits) { $0 }
                        } label: {
                            VStack {
                                Text("Top")
                                Text("Bottom")
                            }
                        }
                        .modified {
                            if #available(iOS 16, *) {
                                $0.pickerStyle(.navigationLink)
                            }
                        }
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
