//
//  SVGLoader.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine
import WebKit

public enum SVGLoader {}

extension SVGLoader {
    
    enum Error: LocalizedError {
        case parse
        case snapshot
    }
    
    public static func publisher(url: URL) -> AnyPublisher<UIImage, Swift.Error> {
        Fetcher.dataPublisher(url: url)
            .flatMap { data in
                publisher(data: data)
            }
            .eraseToAnyPublisher()
    }
    
    public static func publisher(data: Data) -> AnyPublisher<UIImage, Swift.Error> {
        guard let source = String(data: data, encoding: .utf8)
        else {
            return Fail(error: Error.parse)
                .eraseToAnyPublisher()
        }
        let size = try! size(svg: source)
        let frame = CGRect(origin: .zero, size: size)
        // FIXME: Create WKWebView on main thread
        return Just(WKWebView(frame: frame))
            .map { webView -> WebNavigationDelegate in
                let scale = 2.5
                customizeWebView(webView, scale: scale)
                let navigationDelegate = WebNavigationDelegate()
                webView.navigationDelegate = navigationDelegate
                webView.loadHTMLString(source, baseURL: nil)
                return navigationDelegate
            }
            .flatMap { navigationDelegate in
                navigationDelegate.publisher
            }
            .eraseToAnyPublisher()
    }
    
}

private extension SVGLoader {
    
    static func customizeWebView(_ webView: WKWebView, scale: CGFloat) {
        webView.isOpaque = false
        webView.pageZoom = scale
    }
    
    static func size(svg: String) throws -> CGSize {
        // TODO: Replace scanning of all groups with just first match.
        guard let widthString = try svg.groups(regexPattern: "<svg.*?width=\"(.*?)\"").last?.last,
              let heightString = try svg.groups(regexPattern: "<svg.*?height=\"(.*?)\"").last?.last,
              let width = Double(widthString),
              let height = Double(heightString)
        else { throw Error.parse }
        return CGSize(
            width: width,
            height: height
        )
    }
    
}

class WebNavigationDelegate: NSObject {
    let publisher = PassthroughSubject<UIImage, Swift.Error>()
}

extension WebNavigationDelegate {
    
    var snapshotConfiguration: WKSnapshotConfiguration {
        let configuration = WKSnapshotConfiguration()
        configuration.afterScreenUpdates = true
        return configuration
    }
    
}

extension WebNavigationDelegate: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.takeSnapshot(with: snapshotConfiguration) { image, error in
            if let image = image {
                self.publisher.send(image)
                self.publisher.send(completion: .finished)
            } else {
                self.publisher.send(completion: .failure(error ?? SVGLoader.Error.snapshot))
            }
        }
    }
}

// Inspired by https://stackoverflow.com/questions/42789953/swift-3-how-do-i-extract-captured-groups-in-regular-expressions
private extension String {
    func groups(regexPattern: String) throws -> [[String]] {
        try NSRegularExpression(pattern: regexPattern)
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
