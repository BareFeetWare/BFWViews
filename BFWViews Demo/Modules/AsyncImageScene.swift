//
//  AsyncImageScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct AsyncImageScene {
    let urls = [
        URL(string: "https://www.barefeetware.com/logo.png"),
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/02/SVG_logo.svg"),
        Bundle.main.url(forResource: "emptySquare100.svg", withExtension: nil),
        Bundle.main.url(forResource: "filledSquare100.svg", withExtension: nil),
    ]
        .compactMap { $0 }
}

extension AsyncImageScene: View {
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

private extension AsyncImageScene {
    
    func title(url: URL) -> String {
        url.pathComponents.last ?? "?"
    }
    
    func svgImage(url: URL) -> some View {
        AsyncImage(url: url) {
            $0
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
    }
    
}

struct AsyncImageScene_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AsyncImageScene()
        }
    }
}
