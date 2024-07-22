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
        if isZoomable {
            FullScreenFillScene {
                ZoomView {
                    imageView
                }
            }
        } else {
            imageView
        }
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
                .formatted(planImage: self)
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
            .formatted(planImage: planImage)
    }
}

private extension View {
    
    func formatted(planImage: Plan.Image) -> some View {
        self
            .foregroundColor(planImage.foregroundColor)
            .frame(width: planImage.width)
            .frame(minHeight: planImage.backgroundColor != nil ? planImage.width : 0)
            .background(planImage.backgroundColor)
            .cornerRadius(planImage.cornerRadius)
    }
}
