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
    
    public enum Caching {
        case none
        case file
    }
    
    static func dataPublisher(url: URL, caching: Caching) -> AnyPublisher<Data, Error> {
        switch caching {
        case .none:
            return dataPublisher(url: url)
        case .file:
            do {
                let cachedFilePath = try FileManager.default.cachedFilePath(url: url)
                guard FileManager.default.fileExists(atPath: cachedFilePath)
                else {
                    return dataPublisher(url: url)
                        .map { data in
                            // TODO: Add thread safety.
                            debugPrint("Cache writing data to file \(URL(fileURLWithPath: cachedFilePath).lastPathComponent) for URL path: \(url.path)")
                            FileManager.default.createFile(atPath: cachedFilePath, contents: data, attributes: nil)
                            return data
                        }
                        .eraseToAnyPublisher()
                }
                debugPrint("Cache reading data from file \(URL(fileURLWithPath: cachedFilePath).lastPathComponent) for URL path: \(url.path)")
                return dataPublisher(url: URL(fileURLWithPath: cachedFilePath))
                    .eraseToAnyPublisher()
            } catch {
                return Fail<Data, Error>(error: error)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    /// DIrectly fetches, without caching.
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

private extension FileManager {
    func cachedFilePath(url: URL) throws -> String {
        // Create a directory named "Cache" in the app's document directory
        let cacheDirectory = try self.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let cacheFolder = cacheDirectory.appendingPathComponent("Cache", isDirectory: true)

        // Ensure the cache directory exists
        if !self.fileExists(atPath: cacheFolder.path) {
            try self.createDirectory(at: cacheFolder, withIntermediateDirectories: true, attributes: nil)
        }

        // Generate a unique filename based on the stable hash of the URL
        var hasher = Hasher()
        url.hash(into: &hasher)
        let hashValue = hasher.finalize()
        
        let fileName = url.lastPathComponent.isEmpty ? "defaultFileName" : url.lastPathComponent
        let uniqueFileName = "\(fileName)_\(hashValue)"
        let cachedFilePath = cacheFolder.appendingPathComponent(uniqueFileName)

        return cachedFilePath.path
    }
}
