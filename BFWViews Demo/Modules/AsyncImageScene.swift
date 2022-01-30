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
    
    let samples = [
        URL(string: "https://www.barefeetware.com/logo.png"),
        Bundle.main.url(forResource: "emptySquare100.svg", withExtension: nil),
        Bundle.main.url(forResource: "filledSquare100.svg", withExtension: nil),
    ]
        .compactMap { $0 }
    
    init() {
        self.urls = samples
        self._url = State(wrappedValue: self.urls.first!)
    }
    
    let urls: [URL]
    
    @State var url: URL
}

extension AsyncImageScene: View {
    var body: some View {
        VStack {
            HStack {
                Text("URL: ")
                Picker("URL", selection: $url) {
                    ForEach(urls, id: \.self) { url in
                        Text(url.lastPathComponent)
                    }
                }
            }
            AsyncImage(
                url: url
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
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
