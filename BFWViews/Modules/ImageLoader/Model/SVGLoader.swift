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

public extension SVGLoader {
    
    enum Error: LocalizedError {
        case parse
        case snapshot
    }
    
    static func publisher(url: URL) -> AnyPublisher<UIImage, Swift.Error> {
        // TODO: Refactor with switch.
        if let cache = cacheForURL[url],
           case .image(let image) = cache
        {
            debugPrint("cached image     url.last = \(url.lastPathComponent)")
            return Just(image)
                .mapError { _ -> Error in }
                .eraseToAnyPublisher()
        } else if let publisher = publisherForURL[url] {
            debugPrint("cached publisher url.last = \(url.lastPathComponent)")
            return publisher
        } else {
            debugPrint("new publisher    url.last = \(url.lastPathComponent)")
            let publisher = imagePublisher(url: url)
                .share()
                .eraseToAnyPublisher()
            publisherForURL[url] = publisher
            return publisher
        }
    }
    
}

private extension SVGLoader {

    static func imagePublisher(url: URL) -> AnyPublisher<UIImage, Swift.Error> {
        Fetcher.dataPublisher(url: url)
            .tryMap { data -> String in
                guard let source = String(data: data, encoding: .utf8)
                else { throw Error.parse }
                return source
            }
            .tryMap { source in
                try (source, size(svg: source))
            }
            .receive(on: DispatchQueue.main)
            .map { source, size -> WebNavigationDelegate in
                let frame = CGRect(origin: .zero, size: size)
                // WKWebView must be created on the main thread
                // TODO: Use existing webView if cached
                let webView = WKWebView(frame: frame)
                webView.isOpaque = false
                let navigationDelegate = WebNavigationDelegate()
                if self.cacheForURL[url] == nil {
                    self.cacheForURL[url] = .web(.init(webView: webView, navigationDelegate: navigationDelegate))
                }
                webView.navigationDelegate = navigationDelegate
                webView.loadHTMLString(source, baseURL: nil)
                return navigationDelegate
            }
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { navigationDelegate in
                navigationDelegate.imagePublisher
            }
            .map { image in
                if case .image = cacheForURL[url] {
                    // ignore
                } else {
                    cacheForURL[url] = .image(image)
                }
                return image
            }
            .mapError { error in
                debugPrint("error = \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
    
    // TODO: Use NSCache
    
    enum Cache {
        case web(Web)
        case image(UIImage)
        
        struct Web: Hashable {
            let webView: WKWebView
            let navigationDelegate: WebNavigationDelegate
        }
    }
    
    static var publisherForURL = [URL: AnyPublisher<UIImage, Swift.Error>]()
    static var cacheForURL = [URL: Cache]()
    
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
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.correctMargin()
        webView.correctScale()
    }
    
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
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.imagePublisher.send(completion: .failure(error))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.imagePublisher.send(completion: .failure(error))
    }
    
}

private extension WKWebView {
    
    func correctScale() {
        evaluateJavaScript(
            """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width');
            document.getElementsByTagName('head')[0].appendChild(meta);
            """
        )
    }
    
    // Inspired by: https://stackoverflow.com/questions/33027124/strange-padding-while-using-uiwebview-wkwebview/34276426
    func correctMargin() {
        evaluateJavaScript(
            """
            var style = document.createElement('style');
            style.innerHTML = 'body { margin:0; }';
            document.body.appendChild(style);
            """
        )
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