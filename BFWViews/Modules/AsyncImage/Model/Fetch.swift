//
//  Fetch.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine
import CryptoKit

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
}

public extension Fetch {
    
    static func isCached(url: URL) -> Bool {
        FileManager.default.isCached(url: url)
    }
    
    static func flushCache() throws {
        try FileManager.default.flushCache()
    }
    
}

// MARK: - Combine

public extension Fetch {
    
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

// MARK: - Private extensions

private extension FileManager {
    
    func cacheFolderURL() throws -> URL {
        let cacheDirectory = try self.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let cacheFolderURL = cacheDirectory.appendingPathComponent("Downloads", isDirectory: true)
        if !self.fileExists(atPath: cacheFolderURL.path) {
            try self.createDirectory(at: cacheFolderURL, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheFolderURL
    }
    
    func uniqueFileName(url: URL) -> String {
        let urlString = url.absoluteString
        let urlData = Data(urlString.utf8)
        let hash = SHA256.hash(data: urlData)
        let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
        let lastPathComponent = url.lastPathComponent
        let fileName = "\(hashString)_\(lastPathComponent)"
        return fileName
    }
    
    func cachedFilePath(url: URL) throws -> String {
        let cacheFolderURL = try cacheFolderURL()
        
        let uniqueFileName = uniqueFileName(url: url)
        let cachedFilePath = cacheFolderURL.appendingPathComponent(uniqueFileName)
        return cachedFilePath.path
    }
    
    func isCached(url: URL) -> Bool {
        (try? fileExists(atPath: cachedFilePath(url: url))) ?? false
    }
    
    func flushCache() throws {
        let cacheFolderURL = try cacheFolderURL()
        try removeItem(at: cacheFolderURL)
    }
}
