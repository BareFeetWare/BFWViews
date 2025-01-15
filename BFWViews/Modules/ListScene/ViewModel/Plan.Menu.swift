//
//  Plan.Menu.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension Plan {
    
    struct Menu {
        let label: Label
        let sections: [Section]
        
        public struct Section: Identifiable {
            let title: String
            let buttons: [Plan.Button]
            
            public var id: String { title }
            
            public init(_ title: String, buttons: [Plan.Button]) {
                self.title = title
                self.buttons = buttons
            }
        }
        
        public init(label: Label, sections: [Section]) {
            self.label = label
            self.sections = sections
        }
    }
    
}

// MARK: - Views

extension Plan.Menu: View {
    public var body: some View {
        SwiftUI.Menu {
            ForEach(sections) { section in
                SwiftUI.Section(section.title) {
                    ForEach(section.buttons, id: \.title) { button in
                        button
                    }
                }
            }
        } label: {
            label
        }
    }
}

// MARK: - Previews

#Preview {
    Plan.Menu(
        label: .init("Menu", imageSymbol: .ellipsis),
        sections: [
            .init(
                "Section 1",
                buttons: [
                    .init("Button 1.1") {},
                    .init("Button 1.2") {},
                ]
            ),
            .init(
                "Section 2",
                buttons: [
                    .init("Button 2.1") {},
                ]
            )
        ]
    )
}
