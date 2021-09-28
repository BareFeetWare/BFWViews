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
        isResizable: Bool = false,
        loadingView: Loading
    ) {
        self.isResizable = isResizable
        self.loadingView = loadingView
        self.viewModel = ViewModel(url: url)
    }
    
    let isResizable: Bool
    let loadingView: Loading
    @ObservedObject var viewModel: ViewModel
    
}

extension SVGImage: View {
    public var body: some View {
        if let image = viewModel.image {
            if isResizable {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(uiImage: image)
            }
        } else {
            loadingView
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
