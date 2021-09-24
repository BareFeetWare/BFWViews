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
    
    static var webView: WKWebView?
    static var navigationDelegate: WebNavigationDelegate?
    
    public static func publisher(data: Data) -> AnyPublisher<UIImage, Swift.Error> {
        guard let source = String(data: data, encoding: .utf8)
        else {
            return Fail(error: Error.parse)
                .eraseToAnyPublisher()
        }
        let size = try! size(svg: source)
        let frame = CGRect(origin: .zero, size: size)
        return Just(1)
            .receive(on: DispatchQueue.main)
            .map { _ -> WebNavigationDelegate in
                // WKWebView must be created on the main thread
                let webView = WKWebView(frame: frame)
                webView.isOpaque = false
                let scale = 2.5
                webView.pageZoom = scale
                self.webView = webView
                let navigationDelegate = WebNavigationDelegate()
                self.navigationDelegate = navigationDelegate
                webView.navigationDelegate = navigationDelegate
                webView.loadHTMLString(source, baseURL: nil)
                return navigationDelegate
            }
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { navigationDelegate in
                navigationDelegate.imagePublisher
            }
            .eraseToAnyPublisher()
    }
    
}

private extension SVGLoader {
    
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
    let imagePublisher = PassthroughSubject<UIImage, Swift.Error>()
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
                self.imagePublisher.send(image)
                self.imagePublisher.send(completion: .finished)
            } else {
                self.imagePublisher.send(completion: .failure(error ?? SVGLoader.Error.snapshot))
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
