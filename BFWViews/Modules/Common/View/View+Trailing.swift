//
//  View+Trailing.swift
//
//  Created by Tom Brodhurst-Hill on 21/5/20.
//  Copyright © 2020 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func trailing<Content>(
        _ content: () -> Content
    ) -> some View where Content : View
    {
        HStack(spacing: 0) {
            self
            Spacer()
                .layoutPriority(-1)
            content()
        }
    }
}

struct View_Trailing_Previews: PreviewProvider {
    
    static let optionalString: String? = nil
    
    static var previews: some View {
        Group {
            Text("leading")
                .trailing { Text("trailing") }
            Text("nothing trailing")
                .trailing {
                    optionalString.map { Text($0) }
                }
        }
        .previewLayout(.sizeThatFits)
    }
    
}
