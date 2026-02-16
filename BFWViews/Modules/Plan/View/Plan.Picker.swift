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
        
        public init(
            _ title: String,
            selection: Binding<String>,
            options: [String]
        ) {
            self.title = title
            self._selection = selection
            self.options = options
        }
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
                options: ["One", "Two"]
            )
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
