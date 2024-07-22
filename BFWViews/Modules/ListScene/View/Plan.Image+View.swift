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
        Group {
            if isZoomable {
                imageView
                    .onTapFullScreenCover {
                        ZoomView {
                            imageView
                        }
                    }
            } else {
                imageView
            }
        }
        .frame(width: width)
        .frame(minHeight: backgroundColor != nil ? width : 0)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

private extension Plan.Image {
    
    @ViewBuilder
    var imageView: some View {
        switch source {
        case .space:
            Rectangle()
                .foregroundColor(backgroundColor ?? .clear)
                .frame(width: width)
                .frame(minHeight: backgroundColor != nil ? width : 0)
                .cornerRadius(cornerRadius)
        case .uiImage(let uiImage):
            Image(uiImage: uiImage)
                .formattedResizedFit(planImage: self)
        case .url(let url, let caching):
            AsyncImage(
                url: url,
                caching: caching
            ) {
                $0.formattedResizedFit(planImage: self)
            } placeholder: {
                ProgressView()
            }
        case .system(let symbol, let variant, let scale):
            Image(symbol: symbol)
                .symbolVariant(variant)
                .imageScale(scale)
                .foregroundColor(foregroundColor)
        }
    }
}

extension Plan.Image: PreviewProvider {
    public static var previews: some View {
        Plan.Image.preview
    }
}

private extension Image {
    
    func formattedResizedFit(planImage: Plan.Image) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(planImage.foregroundColor)
    }
}
