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
            self.fetchImage(url: url)
        }
        
        @Published var image: UIImage?
        private var subscribers = Set<AnyCancellable>()
        
    }
}

private extension SVGImage.ViewModel {
    
    // Don't call fetchImage from onAppear, since that is only called when the SVGImage first appears and not when reinstiated by an update of the superview, such as with a new URL.
    
    func fetchImage(url: URL) {
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
