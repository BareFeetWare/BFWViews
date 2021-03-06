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
        // TODO: Allow for URL? to match SwiftUI.AsyncImage
        url: URL,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.content = content
        self.placeholder = placeholder()
        self.viewModel = ViewModel(url: url)
    }
    
    let content: (Image) -> Content
    let placeholder: Placeholder
    @ObservedObject var viewModel: ViewModel
    
}

extension AsyncImage where Placeholder == EmptyView {
    public init(
        url: URL,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.init(
            url: url,
            content: content,
            placeholder: { EmptyView() }
        )
    }
}

extension AsyncImage: View {
    public var body: some View {
        if let image = viewModel.image {
            content(Image(uiImage: image))
        } else {
            placeholder
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(
            url: Bundle.main.url(forResource: "SVG_logo.svg", withExtension: nil)!
        ) {
            $0
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
    }
}
