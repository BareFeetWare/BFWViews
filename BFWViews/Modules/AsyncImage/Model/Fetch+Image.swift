//
//  Fetch+Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import Combine
import WebKit

public extension Fetch {
    
    // TODO: Consolidate Caching and Cache
    
    static func imagePublisher(url: URL, caching: Caching) -> AnyPublisher<UIImage, Error> {
        dataPublisher(url: url, caching: caching)
            .flatMap { data in
                imagePublisher(url: url, data: data)
            }
            .eraseToAnyPublisher()
    }
    
    static func imagePublisher(url: URL) -> AnyPublisher<UIImage, Error> {
        // TODO: Refactor with switch.
        if let cache = cacheForURL[url],
           case .image(let image) = cache
        {
            debugPrint("cached image     url = \(url.absoluteString)")
            return Just(image)
                .mapError { _ -> Error in }
                .eraseToAnyPublisher()
        } else if let publisher = publisherForURL[url] {
            debugPrint("cached publisher url = \(url.absoluteString)")
            return publisher
        } else {
            debugPrint("new publisher    url = \(url.absoluteString)")
            let publisher = cachedImagePublisher(url: url)
                .share()
                .eraseToAnyPublisher()
            publisherForURL[url] = publisher
            return publisher
        }
    }
    
}

private extension Fetch {
    
    static func imagePublisher(url: URL, data: Data) -> AnyPublisher<UIImage, Error> {
        guard let image = UIImage(data: data)
        else {
            return svgImagePublisher(url: url, data: data)
        }
        return Just(image)
            .mapError { _ -> Error in }
            .eraseToAnyPublisher()
    }
    
    static func svgImagePublisher(url: URL, data: Data) -> AnyPublisher<UIImage, Error> {
        Just(data)
            .tryMap { data -> String in
                guard let source = String(data: data, encoding: .utf8)
                else { throw FetchError.parse }
                return source
            }
            .tryMap { source in
                try (source, size(svg: source))
            }
            .receive(on: DispatchQueue.main)
            .flatMap { source, size -> AnyPublisher<UIImage, Error> in
                let frame = CGRect(origin: .zero, size: size)
                // WKWebView must be created on the main thread
                let webView = WKWebView(frame: frame)
                webView.isOpaque = false
                let navigationDelegate = WebNavigationDelegate()
                if self.cacheForURL[url] == nil {
                    self.cacheForURL[url] = .web(.init(webView: webView, navigationDelegate: navigationDelegate))
                }
                webView.navigationDelegate = navigationDelegate
                let imagePublisher = navigationDelegate.imagePublisher
                webView.loadHTMLString(source, baseURL: nil)
                return imagePublisher
                    .timeout(30, scheduler: DispatchQueue.main, options: nil) {
                        return FetchError.renderTimeout
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    static func cachedImagePublisher(url: URL) -> AnyPublisher<UIImage, Error> {
        dataPublisher(url: url)
            .flatMap { data in
                imagePublisher(url: url, data: data)
            }
            .map { image in
                if case .image = cacheForURL[url] {
                    // ignore
                } else {
                    /* This deallocates the webView from memory, since it is no longer needed. But deallocation seems to trigger two innocuous side effects in the log:
                     1. [ProcessSuspension] 0x13e0fe300 - ProcessAssertion: Failed to acquire RBS assertion 'ConnectionTerminationWatchdog' for process with PID=XXXXX, error: Error Domain=RBSAssertionErrorDomain Code=2 "Specified target process does not exist" UserInfo={NSLocalizedFailureReason=Specified target process does not exist}
                     2. Could not signal service com.apple.WebKit.WebContent: 113: Could not find specified service
                     */
                    cacheForURL[url] = .image(image)
                }
                return image
            }
            .mapError { error in
                debugPrint("error = \(error.localizedDescription)")
                self.cacheForURL.removeValue(forKey: url)
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
    
    static var publisherForURL = [URL: AnyPublisher<UIImage, Error>]()
    static var cacheForURL = [URL: Cache]()
    
    static func size(svg: String) throws -> CGSize {
        // TODO: Replace scanning of all groups with just first match.
        // TODO: More robust regex.
        guard let widthString = try svg.groups(regexPattern: "<svg.*?width=\"(.*?)\"").last?.last
                ?? svg.groups(regexPattern: "<svg.*?viewBox=\".*? .*? (.*?) .*?\"").last?.last,
              let heightString = try svg.groups(regexPattern: "<svg.*?height=\"(.*?)\"").last?.last
                ?? svg.groups(regexPattern: "<svg.*?viewBox=\".*? .*? .*? (.*?)\"").last?.last,
              let width = Double(widthString),
              let height = Double(heightString)
        else { throw FetchError.parse }
        return CGSize(
            width: width,
            height: height
        )
    }
    
}

class WebNavigationDelegate: NSObject {
    let imagePublisher = PassthroughSubject<UIImage, Error>()
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
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.imagePublisher.send(completion: .failure(FetchError.terminated))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.takeSnapshot(with: snapshotConfiguration) { image, error in
            if let image = image {
                self.imagePublisher.send(image)
                self.imagePublisher.send(completion: .finished)
            } else {
                self.imagePublisher.send(completion: .failure(error ?? FetchError.snapshot))
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
