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
    func modified<V: View>(@ViewBuilder modify: (Self) -> V) -> some View {
        modify(self)
    }
    
    @ViewBuilder
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

struct Modified_Preview: PreviewProvider {
    static var previews: some View {
        List {
            Group {
                Section {
                    Text("Row 1")
                    Text("Row 2")
                }
                Section {
                    Text("Row 1")
                    Text("Row 2")
                }
            }
            .modified {
                if #available(iOS 17.0, *) {
                    $0.listSectionSpacing(.compact)
                } else {
                    $0
                }
            }
        }
    }
}
