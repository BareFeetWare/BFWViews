//
//  IfLet.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/8/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension View {
    
    @ViewBuilder
    func ifLet<V: View, T>(
        _ optional: T?,
        @ViewBuilder then: (T, Self) -> V
    ) -> some View {
        if let optional {
            then(optional, self)
        } else {
            self
        }
    }
    
}

// MARK: - Previews

#Preview {
    Preview()
}

private struct Preview: View {
    
    @State private var badgeCount: Int?
    
    var badgeCountStringBinding: Binding<String> {
        .init(
            get: { self.badgeCount.map { String($0) } ?? "" },
            set: { self.badgeCount = Int($0) }
        )
    }
    
    var body: some View {
        List {
            TextField(
                "Badge Count",
                text: badgeCountStringBinding,
                prompt: Text("0")
            )
            Text("Sample")
                .ifLet(badgeCount) { badgeCount, view in
                    view
                        .overlay(alignment: .topTrailing) {
                            Text(String(badgeCount))
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 4)
                                .background(Color.red)
                                .cornerRadius(4)
                                .offset(x: 4, y: -4)
                        }
                }
        }
    }
}
