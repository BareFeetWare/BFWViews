//
//  Badge.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 10/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func badge<Foreground: View, Background: View>(
        foreground: Foreground,
        background: Background
    ) -> some View {
        HStack(alignment: .top, spacing: -12) {
            self
            foreground
                .font(.caption2)
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(background)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white, lineWidth: 3)
                )
                .offset(CGSize(width: 0, height: -6))
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Image(symbol: .bell)
                .imageScale(.large)
                .foregroundColor(.secondary)
                .badge(
                    foreground: Text("12345")
                        .colorScheme(.dark)
                        .fixedSize(horizontal: true, vertical: false),
                    background: Color.red
                )
            Image(symbol: .heart)
                .imageScale(.large)
                .foregroundColor(.secondary)
                .badge(
                    foreground: Text(" ")
                        .colorScheme(.dark)
                        .fixedSize(horizontal: true, vertical: false),
                    background: Color.green
                )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
