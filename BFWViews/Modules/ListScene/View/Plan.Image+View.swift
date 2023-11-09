//
//  Plan.Image+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.Image: View {
    public var body: some View {
        switch source {
        case .space:
            Rectangle()
                .foregroundColor(backgroundColor ?? .clear)
                .frame(width: width)
                .frame(minHeight: backgroundColor != nil ? width : 0)
                .cornerRadius(cornerRadius)
        case .uiImage(let uiImage):
            Image(uiImage: uiImage)
            // TODO: Consolidate the same modifiers between cases.
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(foregroundColor)
                .frame(width: width)
                .frame(minHeight: backgroundColor != nil ? width : 0)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        case .url(let url):
            AsyncImage(
                url: url
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(foregroundColor)
                    .frame(width: width)
                    .frame(minHeight: backgroundColor != nil ? width : 0)
                    .background(backgroundColor)
                    .cornerRadius(cornerRadius)
            } placeholder: {
                ProgressView()
            }
        case .system(let symbol, let variant, let scale):
            Image(symbol: symbol)
                .symbolVariant(variant)
                .imageScale(scale)
                .foregroundColor(foregroundColor)
                .frame(width: width)
                .frame(minHeight: backgroundColor != nil ? width : 0)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}

extension Plan.Image: PreviewProvider {
    public static var previews: some View {
        Plan.Image.preview
    }
}
