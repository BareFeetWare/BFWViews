//
//  SVGLoaderScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct SVGLoaderScene {
    
    let fileNames = [
        "city.svg",
        "emptySquare100.svg",
        "filledSquare100.svg",
    ]
    
    var urls: [URL] {
        fileNames.map {
            Bundle.main.url(forResource: $0, withExtension: nil)!
        }
    }
    
    let url = Bundle.main.url(forResource: "city", withExtension: "svg")!
}

extension SVGLoaderScene: View {
    var body: some View {
        List(urls, id: \.self) { url in
            NavigationLink(
                destination:
                    svgImage(url: url)
                    .navigationTitle(title(url: url)),
                label: {
                    HStack {
                        Text(title(url: url))
                        Spacer()
                        svgImage(url: url)
                            .background(Color.red.opacity(0.2))
                    }
                    .frame(height: 88)
                }
            )
        }
    }
}

private extension SVGLoaderScene {
    
    func title(url: URL) -> String {
        url.pathComponents.last ?? "?"
    }
    
    func svgImage(url: URL) -> some View {
        SVGImage(
            url: url,
            isResizable: true,
            placeholder: ProgressView()
        )
            .aspectRatio(1, contentMode: .fit)
    }
}

struct SVGImageScene_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SVGLoaderScene()
        }
    }
}
