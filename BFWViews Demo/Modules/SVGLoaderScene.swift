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
    @StateObject var viewModel = ViewModel()
}

extension SVGLoaderScene: View {
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
        } else {
            ProgressView()
                .onAppear { viewModel.loadImage() }
        }
    }
}

import Combine

extension SVGLoaderScene {
    class ViewModel: ObservableObject {
        
        @Published var image: UIImage?
        
        private var subscribers = Set<AnyCancellable>()
    }
}

extension SVGLoaderScene.ViewModel {
    
    func loadImage() {
        loadImage(url: Bundle.main.url(forResource: "city", withExtension: "svg")!)
    }
    
}

extension SVGLoaderScene.ViewModel {
    
    func loadImage(url: URL) {
        SVGLoader
            .publisher(url: url)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        debugPrint("error = \(error)")
                    case.finished:
                        break
                    }
                },
                receiveValue: { self.image = $0}
            )
            .store(in: &subscribers)
    }
    
}

struct SVGImageScene_Preview: PreviewProvider {
    static var previews: some View {
        SVGLoaderScene()
    }
}
