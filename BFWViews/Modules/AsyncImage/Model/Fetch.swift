//
//  Fetch.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine

public enum FetchError: LocalizedError {
    case httpResponse(HTTPURLResponse, data: Data)
    case parse
    case snapshot
    case renderTimeout
    case terminated
}

public enum Fetch {
    
    static func dataPublisher(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 400
                {
                    throw FetchError.httpResponse(
                        httpResponse,
                        data: data
                    )
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
}
