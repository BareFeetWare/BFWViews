//
//  Fetcher+Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine
import SwiftUI // Only for Image

extension Fetcher {
    
    static var imageForURL: [URL: Image] = [:]
    
    static func imagePublisher(url: URL) -> AnyPublisher<Image, Swift.Error> {
        if let image = imageForURL[url] {
            return Just<Image>(image)
                .mapError { _ -> Swift.Error in }
                .eraseToAnyPublisher()
        } else {
            return dataPublisher(url: url)
                .tryMap { data in
                    guard let image = Image(data: data)
                    else { throw Error.notAnImage }
                    return image
                }
                .eraseToAnyPublisher()
        }
    }
    
}

