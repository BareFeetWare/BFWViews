//
//  SVGImage.ViewModel.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 25/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine
import UIKit // For UIImage

extension SVGImage {
    class ViewModel: ObservableObject {
        
        init(url: URL) {
            self.url = url
        }
        
        @Published var image: UIImage?
        
        let url: URL
        private var subscribers = Set<AnyCancellable>()
        
    }
}

extension SVGImage.ViewModel {
    
    func onAppear() {
        if subscribers.isEmpty {
            subscribe()
        }
    }
    
}

private extension SVGImage.ViewModel {
    
    func subscribe() {
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
