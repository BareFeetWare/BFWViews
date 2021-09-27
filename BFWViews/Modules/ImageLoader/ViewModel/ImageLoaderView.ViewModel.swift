//
//  ImageLoaderView.ViewModel.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 25/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine

extension ImageLoaderView {
    class ViewModel: ObservableObject {
        
        init(
            url: URL,
            isResizable: Bool
        ) {
            self.url = url
            self.isResizable = isResizable
        }
        
        let url: URL
        let isResizable: Bool
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
