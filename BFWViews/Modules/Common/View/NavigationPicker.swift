//
//  NavigationPicker.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/8/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

// TODO: Consolidate with NavigationOptionalPicker

struct NavigationPicker<Option: Identifiable & View> {
    let title: String
    let selection: Binding<Option>
    let options: [Option]?
    @State var isActive = false
    
    init(
        _ title: String,
        selection: Binding<Option>,
        options: [Option]
    ) {
        self.title = title
        self.selection = selection
        self.options = options
    }
}

extension NavigationPicker where Option == IdentifiableText {
    
    init(
        _ title: String,
        selection: Binding<String>,
        options: [String]?
    ) {
        self.title = title
        self.selection = selection.map { IdentifiableText($0) } reverse: { $0.title }
        self.options = options?.map { IdentifiableText($0) }
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
    var body: some View {
        if let options {
            NavigationLink(isActive: $isActive) {
                Form {
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
    
    struct StringPreview: View {
        @State var selection: String = "apple"
        let fruits: [String] = ["apple", "banana", "orange"]
        
        var body: some View {
            NavigationView {
                Form {
                    NavigationPicker(
                        "Fruit",
                        selection: $selection,
                        options: fruits
                    )
                }
                .navigationTitle("Text Picker")
            }
        }
    }
    
    struct Preview: View {
        @State var selection: Fruit = .apple
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
                        "Fruit",
                        selection: $selection,
                        options: fruits
                    )
                }
                .navigationTitle("View Picker")
            }
        }
    }
}
