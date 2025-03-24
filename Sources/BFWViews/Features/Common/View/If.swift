//
//  Modified.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 30/8/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension View {
    
    @ViewBuilder
    func `if`<V: View, U: View>(
        _ condition: Bool,
        @ViewBuilder then: (Self) -> V,
        @ViewBuilder else: (Self) -> U
    ) -> some View {
        if condition {
            then(self)
        } else {
            `else`(self)
        }
    }
    
    @ViewBuilder
    func `if`<V: View>(
        _ condition: Bool,
        @ViewBuilder then: (Self) -> V,
    ) -> some View {
        if condition {
            then(self)
        } else {
            self
        }
    }
    
}

public extension View {
    
    @ViewBuilder
    @available(*, deprecated, message: "Use .if() instead.")
    func modified<V: View>(
        if condition: Bool,
        @ViewBuilder modify: (Self) -> V
    ) -> some View {
        if condition {
            modify(self)
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
    
    @State private var isTrue: Bool = false
    
    var body: some View {
        List {
            Toggle(isOn: $isTrue) {
                Text("Is True")
                    .if(isTrue) {
                        $0.foregroundColor(.green)
                    } else: {
                        $0
                            .foregroundColor(.red)
                            .strikethrough(true)
                    }
            }
        }
    }
}
