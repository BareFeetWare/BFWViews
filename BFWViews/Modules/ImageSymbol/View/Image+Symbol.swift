//
//  Image+Symbol.swift
//
//  Created by Tom Brodhurst-Hill on 5/2/20.
//  Copyright © 2020 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Image {
    
    init(symbol: ImageSymbol, variableValue: Double? = nil) {
        if #available(iOS 16.0, *) {
            self.init(systemName: symbol.name, variableValue: variableValue)
        } else {
            self.init(systemName: symbol.name)
        }
    }
    
}

// MARK: - Previews

struct Image_Symbol_Previews: PreviewProvider {
    static var previews: some View {
        Image(symbol: .heart)
            .previewLayout(.sizeThatFits)
    }
}
