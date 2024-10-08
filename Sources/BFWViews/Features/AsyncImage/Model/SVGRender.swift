//
//  SVGRender.swift
//
//  Created by Tom Brodhurst-Hill on 15/3/2024.
//

import UIKit
import WebKit

enum SVGRender {
    
    enum Error: LocalizedError {
        case invalidSize
        case sizeNotFound
        case stringFromData
        
        var errorDescription: String? {
            String(describing: self)
        }
    }
    
    static func utf8String(data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.stringFromData
        }
        return string
    }
    
    static func image(svgData: Data) async throws -> UIImage {
        let string = try utf8String(data: svgData)
        let image = try await image(svgString: string)
        return image
    }
    
    @MainActor
    static func image(svgString: String) async throws -> UIImage {
        let size = try size(svgString: svgString)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let webView = WKWebView(frame: rect)
        webView.isOpaque = false
        webView.loadHTMLString(svgString, baseURL: nil)
        // TODO: Delay snapshot until ready, without using hard time delay.
        while webView.isLoading {
            try await Task.sleep(seconds: 0.1)
        }
        let image = try await webView.snapshotImage()
        return image
    }
    
    static func widthHeightSize(svgString: String) throws -> CGSize {
        // TODO: Optimise pattern
        let pattern = #"width\s*=\s*"([^"]+)"\s*height\s*=\s*"([^"]+)""#
        guard let range = svgString.range(of: pattern, options: .regularExpression)
        else { throw Error.sizeNotFound }
        let widthString = String(svgString[range].split(separator: "\"")[1])
        let heightString = String(svgString[range].split(separator: "\"")[3])
        guard let width = Double(widthString), let height = Double(heightString)
        else { throw Error.invalidSize }
        return CGSize(width: width, height: height)
    }
    
    static func viewBoxSize(svgString: String) throws -> CGSize {
        let pattern = #"<svg.*?viewBox="(.*?)\s(.*?)\s(.*?)\s(.*?)""#
        let groups = try svgString.groups(regexPattern: pattern)
        guard let values = groups.first,
              values.count == 5,
              let width = Double(values[3]),
              let height = Double(values[4])
        else { throw Error.invalidSize }
        return CGSize(width: width, height: height)
    }
    
    static func size(svgString: String) throws -> CGSize {
        let size = try (try? widthHeightSize(svgString: svgString))
        ?? viewBoxSize(svgString: svgString)
        return size
    }
}

private extension WKWebView {
    func snapshotImage() async throws -> UIImage {
        let config = WKSnapshotConfiguration()
        config.rect = bounds
        config.afterScreenUpdates = true
        let image = try await takeSnapshot(configuration: config)
        return image
    }
}

private extension Task where Failure == Never, Success == Never {
    static func sleep(seconds: TimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(seconds * 1e9))
    }
}

// Inspired by https://stackoverflow.com/questions/42789953/swift-3-how-do-i-extract-captured-groups-in-regular-expressions
private extension String {
    func groups(regexPattern: String) throws -> [[String]] {
        try NSRegularExpression(
            pattern: regexPattern,
            options: .dotMatchesLineSeparators
        )
        .matches(
            in: self,
            range: NSRange(startIndex..., in: self)
        )
        .map { match in
            (0 ..< match.numberOfRanges)
                .map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: self) else {
                        return ""
                    }
                    return String(self[range])
                }
        }
    }
}
