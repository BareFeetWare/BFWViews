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
                .frame(width: width)
                .foregroundColor(color ?? .clear)
        case .url(let url):
            AsyncImage(
                url: url
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width)
                    .foregroundColor(color)
                    .cornerRadius(cornerRadius)
            } placeholder: {
                ProgressView()
            }
        case .system(let name, let scale):
            Image(systemName: name)
                .imageScale(scale)
                .frame(width: width)
                .foregroundColor(color)
        }
    }
}

extension Plan.Image: PreviewProvider {
    public static var previews: some View {
        Plan.Image.preview
    }
}
