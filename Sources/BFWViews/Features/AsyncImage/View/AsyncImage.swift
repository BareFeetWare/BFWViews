//
//  AsyncImage.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 25/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct AsyncImage<Content: View, Placeholder: View> {
    
    public init(
        url: URL?,
        caching: Fetch.Caching,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.caching = caching
        self.content = content
        self.placeholder = placeholder
    }
    
    let url: URL?
    let caching: Fetch.Caching
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State var image: UIImage?
    @State var error: Error?
}

extension AsyncImage where Placeholder == EmptyView {
    public init(
        url: URL,
        caching: Fetch.Caching,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.init(
            url: url,
            caching: caching,
            content: content,
            placeholder: { EmptyView() }
        )
    }
}

private extension AsyncImage {
    
    var isVisiblePlaceholder: Bool {
        !isLocalFile
    }
    
    var errorImage: Plan.Image? {
        guard error != nil else { return nil }
        return .system(symbol: .network, variants: .slash, foregroundColor: .orange)
    }
    
    var isLocalFile: Bool {
        guard let url else { return false }
        return caching == .file && Fetch.isCached(url: url)
        || url.isFileURL
    }
    
    // Don't call fetchImage() from onAppear, since that is only called when the AsyncImage first appears and not when reinstantiated by an update of the superview, such as with a new URL.
    
    func fetchImage() {
        guard let url else {
            self.image = nil
            return
        }
        Task {
            do {
                self.image = try await Fetch.image(url: url, caching: caching)
            } catch {
                debugPrint("image error = \(error)")
                self.error = error
            }
        }
    }
    
    func task() {
        fetchImage()
    }
}

// MARK: - View

extension AsyncImage: View {
    public var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else if let errorImage {
                errorImage
                    .padding()
            } else if isVisiblePlaceholder {
                placeholder()
            } else {
                // Required to appear so task is called.
                Color.clear
            }
        }
        .task(id: url) { task() }
    }
}

// MARK: - Preview

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(
            url: Bundle.main.url(forResource: "SVG_logo.svg", withExtension: nil)!,
            caching: .file
        ) {
            $0
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
    }
}
