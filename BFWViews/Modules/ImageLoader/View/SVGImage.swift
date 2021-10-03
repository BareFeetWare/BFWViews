//
//  SVGImage.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 25/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct SVGImage<Content: View, Placeholder: View> {
    
    public init(
        // TODO: Allow for URL? to match AsyncImage
        url: URL,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.content = content
        self.placeholder = placeholder()
        // Inspired by: https://stackoverflow.com/a/62636048/1532648
        _viewModel = StateObject(wrappedValue: ViewModel(url: url))
    }
    
    let content: (Image) -> Content
    let placeholder: Placeholder
    @StateObject var viewModel: ViewModel
    
}

extension SVGImage: View {
    public var body: some View {
        if let image = viewModel.image {
            content(Image(uiImage: image))
        } else {
            placeholder
        }
    }
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        SVGImage(
            url: Bundle.main.url(forResource: "city", withExtension: "svg")!
        ) {
            $0.resizable()
        } placeholder: {
            ProgressView()
        }
    }
}
