//
//  Card.swift
//
//  Created by Dani on 7/10/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct Card {
    
    @Environment(\.colorScheme) var colorScheme
    
    var padding: Edge.Set = .vertical
    var internalPadding: Edge.Set = .vertical
}

extension Card {
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 16
    
    public enum Color {
        public static let background = SwiftUI.Color(.secondarySystemGroupedBackground)
        public static let shadow = SwiftUI.Color.secondary.opacity(0.2)
        public static let outside = SwiftUI.Color(.systemGroupedBackground)
    }
    
    var shadowRadius: CGFloat {
        switch colorScheme {
        case .light: return Card.shadowRadius
        default: return 0
        }
    }
}

extension Card: ViewModifier {
    public func body(content: Content) -> some View {
        // VStack is needed to join the components in self together into one view for subsequent modifiers.
        VStack {
            content
        }
        .padding(internalPadding)
        .background(Card.Color.background)
        .clipShape(RoundedRectangle(cornerRadius: Card.cornerRadius))
        .shadow(color: Card.Color.shadow, radius: shadowRadius)
        .padding(padding)
    }
}

public extension View {
    func card(
        padding: Edge.Set = .init(),
        internalPadding: Edge.Set = .vertical
    ) -> some View {
        modifier(
            Card(
                padding: padding,
                internalPadding: internalPadding
            )
        )
    }
}

struct Card_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases) { colorScheme in
            Group {
                Form {
                    Text("Form, for comparison")
                }
                .frame(height: 120)
                VStack(alignment: .leading, spacing: 16) {
                    Section(
                        header:
                            Text("Header 1")
                            .font(.headline)
                    ) {
                        Text("Row 1")
                    }
                }
                .padding(.horizontal)
                .card(padding: .bottom)
                VStack(alignment: .leading, spacing: 16) {
                    Section(
                        header:
                            Text("Header 1")
                            .font(.headline)
                    ) {
                        Text("Row 1")
                        Text("Row 2")
                    }
                    Section(
                        header:
                            Text("Section 2")
                            .font(.headline)
                    ) {
                        Text("Section 2, Row 1")
                        Text("Section 2, Row 2")
                    }
                }
                .padding(.horizontal)
                .card()
            }
            .background(Card.Color.outside)
            .colorScheme(colorScheme)
        }
        .previewLayout(.sizeThatFits)
    }
}
