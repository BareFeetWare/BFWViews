//
//  Plan.Rating+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 16/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Rating: View {
    public var body: some View {
        HStack {
            title.map {
                Text($0)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            ForEach(1...maximum, id: \.self) { index in
                Button {
                    selection = index
                } label: {
                    Image(symbol: index <= selection ? .starFill : .star)
                }
                // Tap on button, rather than encompassing cell:
                .buttonStyle(.borderless)
            }
        }
    }
}

struct PlanRating_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Rating.preview
    }
}
