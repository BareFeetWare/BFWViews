//
//  ImageLoaderScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 20/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ImageLoaderScene {
    let urls = [
        URL(string: "https://www.barefeetware.com/logo.png"),
        URL(string: "https://en.wikipedia.org/wiki/File:SVG_Logo.svg")
        ]
        .compactMap { $0 }
}

extension ImageLoaderScene: View {
    var body: some View {
        List(urls, id: \.self) { url in
            HStack {
                Text(url.pathComponents.last!)
                Spacer()
                ImageLoaderView(url: url)
                    .frame(width: 100, height: 100)
            }
        }
        .navigationTitle("ImageLoader")
    }
}

struct ImageLoaderScene_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderScene()
    }
}
