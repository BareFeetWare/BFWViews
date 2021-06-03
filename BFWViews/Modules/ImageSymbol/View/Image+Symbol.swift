//
//  Image+Symbol.swift
//
//  Created by Tom Brodhurst-Hill on 5/2/20.
//  Copyright © 2020 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Image {
    init(symbol: ImageSymbol) {
        self.init(systemName: symbol.name)
    }
}

struct Image_Symbol_Previews: PreviewProvider {
    static var previews: some View {
        Image(symbol: .heart)
            .previewLayout(.sizeThatFits)
    }
}
