//
//  SVGImage.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 25/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct SVGImage<Loading: View> {
    
    public init(
        url: URL,
        loadingView: Loading
    ) {
        self.loadingView = loadingView
        self.viewModel = ViewModel(url: url)
    }
    
    let loadingView: Loading
    @ObservedObject var viewModel: ViewModel
    
}

extension SVGImage: View {
    public var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
        } else {
            loadingView
                .onAppear { viewModel.onAppear() }
        }
    }
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        SVGImage(
            url: Bundle.main.url(forResource: "city", withExtension: "svg")!,
            loadingView: ProgressView()
        )
    }
}
