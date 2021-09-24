//
//  Fetcher.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine

enum Fetcher {
    
    enum Error: LocalizedError {
        case httpResponse(HTTPURLResponse, data: Data)
        case notAnImage
    }
    
    static func dataPublisher(url: URL) -> AnyPublisher<Data, Swift.Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 400
                {
                    throw Error.httpResponse(
                        httpResponse,
                        data: data
                    )
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
}
