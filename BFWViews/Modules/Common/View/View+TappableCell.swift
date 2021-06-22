//
//  View+TappableCell.swift
//
//  Created by Tom Brodhurst-Hill on 3/12/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func tappableCell(
        symbol: ImageSymbol? = .chevronRight
    ) -> some View {
        HStack {
            self
                .foregroundColor(.primary)
            Spacer()
                .layoutPriority(-1)
            symbol.map { Image(symbol: $0) }
                .foregroundColor(Color(UIColor.secondarySystemFill))
                .imageScale(.small)
                .font(Font.body.weight(.semibold))
        }
        .frame(minHeight: 36)
    }
    
    func tappableCell(
        title: String? = nil,
        filename: String = #file,
        symbol: ImageSymbol? = .chevronRight,
        action: @escaping () -> Void
    ) -> some View {
        tappableCell(symbol: symbol)
            // Note: .contentShape(Rectangle()) is required to extend the tappable area across the whole cell width.
            .contentShape(Rectangle())
            .onTapGesture() {
                action()
            }
    }
}

struct View_TappableCell_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases) { colorScheme in
            Group {
                VStack {
                    Text("Push")
                        .tappableCell()
                    Divider()
                    Text("Expand")
                        .tappableCell(symbol: .chevronDown)
                }
                .padding(.horizontal)
                List {
                    NavigationLink("NavigationLink, for comparison", destination: Text("Test"))
                }
                .frame(height: 50)
            }
            .background(Color(.systemBackground))
            .colorScheme(colorScheme)
        }
        .previewLayout(.sizeThatFits)
    }
}
