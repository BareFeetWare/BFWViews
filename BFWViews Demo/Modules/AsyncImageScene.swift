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
        URL(string: "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/heart.svg"),
        URL(string: "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/circles1.svg"),
        URL(string: "https://vex-staging.fly.dev/images/icons/Isolation_Icon.svg"),
        URL(string: "https://vex-staging.fly.dev/images/icons/Exclusive_Control_2.svg"),
        Bundle.main.url(forResource: "emptySquare100.svg", withExtension: nil),
        Bundle.main.url(forResource: "filledSquare100.svg", withExtension: nil),
    ]
        .compactMap { $0 }
    
    init() {
        self.urls = samples
        self.selectedURL = self.urls.first!
    }
    
    let urls: [URL]
    let cachings = Fetch.Caching.allCases
    
    @State var selectedURL: URL
    @State var selectedCaching: Fetch.Caching = .none
    @State var imageURL: URL?
    @State var imageCaching: Fetch.Caching = .none
    @State var isVisibleBackground = false
    @State var error: Error?
}

extension AsyncImageScene {
    
    func onTapLoadImage() {
        imageURL = selectedURL
        imageCaching = selectedCaching
    }
    
    func onTapFlushCache() {
        do {
            try Fetch.flushCache()
        } catch {
            self.error = error
        }
    }
    
    var isCachedSelectedURLString: String {
        Fetch.isCached(url: selectedURL)
        ? "Yes"
        : "No"
    }
    
    var isCachedImageURLString: String {
        guard let imageURL else { return ""}
        return Fetch.isCached(url: imageURL)
        ? "Yes"
        : "No"
    }
    
    var isPresentedErrorBinding: Binding<Bool> {
        .init {
            error != nil
        } set: { isPresented in
            if !isPresented {
                error = nil
            }
        }
    }
    
}

extension AsyncImageScene: View {
    var body: some View {
        List {
            Section {
                Picker("URL", selection: $selectedURL) {
                    ForEach(urls, id: \.self) { url in
                        Text(url.lastPathComponent)
                    }
                }
            }
            Section("Cache") {
                Picker("Caching", selection: $selectedCaching) {
                    ForEach(cachings, id: \.self) { caching in
                        Text(String(describing: caching).capitalized)
                    }
                }
                HStack {
                    Text("Is cached")
                    Spacer()
                    Text(isCachedSelectedURLString)
                }
                Button("Flush Cache") { onTapFlushCache() }
            }
            Section {
                Button("Load Image") { onTapLoadImage() }
            }
            Section("Image") {
                Toggle("Color background", isOn: $isVisibleBackground)
                image
            }
        }
        .navigationTitle("AsyncImage")
        .alert(isPresented: isPresentedErrorBinding) {
            Alert(
                title: Text("Error"),
                message:
                    error.map { Text("\($0)") }
            )
        }
    }
    
    @ViewBuilder
    var image: some View {
        if let imageURL {
            BFWViews.AsyncImage(
                url: imageURL,
                caching: imageCaching
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(isVisibleBackground ? Color.yellow : nil)
            } placeholder: {
                ProgressView()
            }
            HStack {
                Text("Is cached")
                Spacer()
                Text(isCachedImageURLString)
            }
        } else {
            Text("None loaded")
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
