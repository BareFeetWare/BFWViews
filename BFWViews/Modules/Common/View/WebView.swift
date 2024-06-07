//
//  WebView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

// Inspired by https://developer.apple.com/forums/thread/126986

import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    
    public init(
        title: Binding<String>,
        urlRequest: URLRequest,
        loadStatusChanged: ((Bool, Error?) -> Void)? = nil,
        policyForNavigationAction: ((_ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy)? = nil
    ) {
        self.title = title
        self.urlRequest = urlRequest
        self.loadStatusChanged = loadStatusChanged
        self.policyForNavigationAction = policyForNavigationAction
    }
    
    let title: Binding<String>
    let urlRequest: URLRequest
    var loadStatusChanged: ((Bool, Error?) -> Void)?
    let policyForNavigationAction: ((_ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy)?
    
    public func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(urlRequest)
        return view
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title.wrappedValue = webView.title ?? ""
            parent.loadStatusChanged?(false, nil)
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let policyForNavigationAction = parent.policyForNavigationAction else { return }
            let policy = policyForNavigationAction(navigationAction)
            decisionHandler(policy)
        }
        
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(
            title: .constant("Title"),
            urlRequest: URLRequest(url: URL(string: "https://www.barefeetware.com")!),
            loadStatusChanged: nil
        )
    }
}
