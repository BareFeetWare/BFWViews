//
//  Fetch.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import CryptoKit

public enum FetchError: LocalizedError {
    case empty
    case httpResponse(HTTPURLResponse, data: Data)
    
    public var errorDescription: String? {
        switch self {
        case .httpResponse(let response, _):
            "http response error: " + response.description
        default:
            "Fetch error: \(self)"
        }
    }
}

public enum Fetch {
    
    public enum Caching: CaseIterable, Identifiable {
        case none
        case file
        
        public var id: Self { self }
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

// MARK: - Network

public extension Fetch {
    
    static func data(url: URL, caching: Caching) async throws -> Data {
        switch caching {
        case .none:
            return try await data(url: url)
        case .file:
            let data: Data
            let cachedFilePath = try FileManager.default.cachedFilePath(url: url)
            if FileManager.default.fileExists(atPath: cachedFilePath) {
                let cachedFileURL = URL(fileURLWithPath: cachedFilePath)
                debugPrint("Cache reading data from file \(cachedFileURL.lastPathComponent) for URL path: \(url.path)")
                data = try await self.data(url: cachedFileURL)
            } else {
                try await data = self.data(url: url)
                guard !data.isEmpty else { throw FetchError.empty }
                // TODO: Add thread safety.
                //debugPrint("Cache writing data to file \(URL(fileURLWithPath: cachedFilePath).lastPathComponent) for URL path: \(url.path)")
                FileManager.default.createFile(atPath: cachedFilePath, contents: data, attributes: nil)
            }
            return data
        }
    }
    
    /// DIrectly fetches, without caching.
    static func data(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 400
        {
            throw FetchError.httpResponse(
                httpResponse,
                data: data
            )
        } else {
            return data
        }
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
