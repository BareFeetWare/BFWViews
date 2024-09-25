//
//  NavigationOptionalPicker.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/8/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

// TODO: Consolidate with NavigationPicker

public struct NavigationOptionalPicker<Option: Identifiable & View> where Option.ID == String {
    let title: String
    let selection: Binding<Option?>
    let options: [Option]?
    @State var isActive = false
    
    public init(
        _ title: String,
        selection: Binding<Option?>,
        options: [Option]
    ) {
        self.title = title
        self.selection = selection
        self.options = options
    }
    
    func onTap(option: Option?) {
        selection.wrappedValue = option
    }
    
}

public extension NavigationOptionalPicker where Option == IdentifiableText {
    init(
        _ title: String,
        selection: Binding<String?>,
        options: [String]
    ) {
        self.title = title
        self.selection = selection.map {
            $0.map { IdentifiableText($0) }
        } reverse: {
            $0?.title
        }
        self.options = options.map { IdentifiableText($0) }
    }
}

private struct OptionalTickRow<Option: View & Identifiable> {
    @Binding var selection: Option?
    let option: Option?
    @Environment(\.dismiss) var dismiss
    
    var id: String {
        id(option: option)
    }
    
    func id(option: Option?) -> String {
        option.map { "row.id: \($0.id)" } ?? "nil"
    }
    
    func onTap(option: Option?) {
        selection = option
        dismiss()
    }
}

private struct OptionalView<Content: View> {
    let content: () -> Content?
    let nilString: String = "None"
}

// MARK: - Views

extension NavigationOptionalPicker: View {
    public var body: some View {
        if let options {
            NavigationLink(isActive: $isActive) {
                Form {
                    Section {
                        tickRow(option: nil)
                    }
                    Section {
                        ForEach(options) { option in
                            tickRow(option: option)
                        }
                    }
                }
                .navigationTitle(title)
            } label: {
                HStack {
                    Text(title)
                    Spacer()
                    OptionalView { selection.wrappedValue }
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
    
    func tickRow(option: Option?) -> some View {
        OptionalTickRow(selection: selection, option: option)
    }
}

extension OptionalView: View {
    var body: some View {
        if let content = content() {
            content
        } else {
            Text(nilString)
        }
    }
}

extension OptionalTickRow: View {
    var body: some View {
        Button {
            onTap(option: option)
        } label: {
            HStack {
                OptionalView { option }
                Spacer()
                if option?.id == selection?.id {
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

struct NavigationOptionalPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        FruitsPreview()
            .previewDisplayName("Fruits")
        StringsPreview()
            .previewDisplayName("Strings")
    }
    
    struct FruitsPreview: View {
        @State var selection: Fruit?
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
                    NavigationOptionalPicker(
                        "Fruit",
                        selection: $selection,
                        options: fruits
                    )
                }
                .navigationTitle("Fruits")
            }
        }
    }
    
    struct StringsPreview: View {
        @State var selection: String?
        let options: [String] = ["apple", "banana", "orange"]
        
        var body: some View {
            NavigationView {
                Form {
                    NavigationOptionalPicker(
                        "Fruit",
                        selection: $selection,
                        options: options
                    )
                }
                .navigationTitle("Strings")
            }
        }
    }

}
