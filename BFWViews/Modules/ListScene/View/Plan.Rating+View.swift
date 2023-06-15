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
                    onTap(index: index)
                } label: {
                    Image(symbol: symbol(index: index))
                        .imageScale(.large)
                }
                // Make tap received by button, rather than by encompassing cell:
                .buttonStyle(.borderless)
            }
        }
    }
}

struct PlanRating_Previews: PreviewProvider {
    
    struct Five: View {
        @State var selection: Int = 0
        
        var body: some View {
            Plan.Rating(
                title: "Title",
                maximum: 5,
                selection: $selection
            )
        }
        
    }
    
    struct Seven: View {
        @State var selection: Int = 0
        
        var body: some View {
            Plan.Rating(
                title: "Energy Rating",
                maximum: 7,
                selection: $selection
            )
        }
        
    }
    
    static var previews: some View {
        List {
            Five()
            Seven()
        }
        .previewLayout(.sizeThatFits)
    }
    
}
