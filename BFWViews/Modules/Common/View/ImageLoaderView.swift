//
//  ImageLoaderView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 20/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct ImageLoaderView {
    
    public init(
        url: URL
    ) {
        self.viewModel = .init(url: url)
    }
    
    @ObservedObject var viewModel: ViewModel
    
}

extension ImageLoaderView: View {
    public var body: some View {
        ZStack {
            viewModel.imageData.map {
                Image(data: $0)
            }
        }
        .onAppear { viewModel.onAppear() }
    }
}

import Combine

extension ImageLoaderView {
    class ViewModel: ObservableObject {
        
        init(url: URL) {
            self.url = url
        }
        
        let url: URL
        @Published var imageData: Data?
        
        private var subscribers = Set<AnyCancellable>()
    }
}

extension ImageLoaderView.ViewModel {
    
    func onAppear() {
        if subscribers.isEmpty {
            subscribe()
        }
    }

}

private extension ImageLoaderView.ViewModel {

    func subscribe() {
        Fetcher.dataPublisher(url: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): debugPrint("error = \(error)")
                    case .finished: break
                    }
                },
                receiveValue: {
                    self.imageData = $0
                }
            )
            .store(in: &subscribers)
    }
    
}

struct ImageLoaderView_Previews: PreviewProvider {
    
    static let url = URL(string: "https://www.barefeetware.com/logo.png")!
    
    static var previews: some View {
        Group {
            ImageLoaderView(url: url)
            // For comparison:
            if #available(iOS 15.0, *) {
                AsyncImage(url: url) { image in
                    image
                        .background(Color.green)
                } placeholder: {
                    ProgressView()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
