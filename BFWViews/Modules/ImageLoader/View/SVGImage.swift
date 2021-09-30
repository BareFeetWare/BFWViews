//
//  SVGImage.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 25/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct SVGImage<Placeholder: View> {
    
    public init(
        url: URL,
        isResizable: Bool = false,
        placeholder: Placeholder
    ) {
        self.isResizable = isResizable
        self.placeholder = placeholder
        // Inspired by: https://stackoverflow.com/a/62636048/1532648
        _viewModel = StateObject(wrappedValue: ViewModel(url: url))
    }
    
    let isResizable: Bool
    let placeholder: Placeholder
    @StateObject var viewModel: ViewModel
    
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
            placeholder
        }
    }
}

struct SVGImage_Previews: PreviewProvider {
    static var previews: some View {
        SVGImage(
            url: Bundle.main.url(forResource: "city", withExtension: "svg")!,
            placeholder: ProgressView()
        )
    }
}
