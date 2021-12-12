//
//  Badge.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 10/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    
    func badge<Background: View>(
        background: Background
    ) -> some View {
        HStack(alignment: .top, spacing: -12) {
            self
            Text(" ")
                .foregroundStyle()
                .background(background)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 3)
                )
                .backgroundStyle()
        }
    }
    
    // TODO: Consolidate the two functions
    
    func badge<Foreground: View, Background: View>(
        foreground: Foreground,
        background: Background
    ) -> some View {
        HStack(alignment: .top, spacing: -12) {
            self
            foreground
                .foregroundStyle()
                .background(background)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white, lineWidth: 3)
                )
                .backgroundStyle()
        }
    }
    
}

private extension View {
    
    func foregroundStyle() -> some View {
        self
            .font(.caption2.bold())
            .fixedSize(horizontal: true, vertical: false)
            .padding(.vertical, 3)
            .padding(.horizontal, 8)
    }
    
    func backgroundStyle() -> some View {
        self
            .offset(CGSize(width: 0, height: -6))
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
                        .colorScheme(.dark),
                    background: Color.red
                )
            Image(symbol: .heart)
                .imageScale(.large)
                .foregroundColor(.secondary)
                .badge(
                    background: Color.green
                )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
