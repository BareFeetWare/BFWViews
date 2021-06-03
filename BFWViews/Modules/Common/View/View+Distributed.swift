//
//  View+Distributed.swift
//
//  Created by Tom Brodhurst-Hill on 30/9/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    
    func distributed(_ alignment: VerticalAlignment) -> some View {
        VStack(spacing: 0) {
            if [.bottom, .center].contains(alignment) {
                CompressibleSpacer()
            }
            self
            if [.top, .center].contains(alignment) {
                CompressibleSpacer()
            }
        }
    }
    
    func distributed(_ alignment: HorizontalAlignment) -> some View {
        HStack(spacing: 0) {
            if [.trailing, .center].contains(alignment) {
                CompressibleSpacer()
            }
            self
            if [.leading, .center].contains(alignment) {
                CompressibleSpacer()
            }
        }
    }
    
}

struct View_Distributed_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("top").distributed(.top)
            Text("center").distributed(VerticalAlignment.center)
            Text("bottom").distributed(.bottom)
            Text("leading").distributed(.leading)
            Text("center").distributed(HorizontalAlignment.center)
            Text("trailing").distributed(.trailing)
        }
        .background(Color.yellow)
        .previewLayout(.fixed(width: 200, height: 50))
    }
}
