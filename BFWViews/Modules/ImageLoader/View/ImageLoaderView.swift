//
//  ImageLoaderView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 20/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct ImageLoaderView {
    
    public init(
        url: URL,
        isResizable: Bool = false
    ) {
        self.viewModel = .init(url: url, isResizable: isResizable)
    }
    
    @ObservedObject var viewModel: ViewModel
    
}

extension ImageLoaderView: View {
    public var body: some View {
        ZStack {
            viewModel.imageData.map { data in
                Group {
                    if viewModel.isResizable {
                        Image(data: data)?
                            .resizable()
                    } else {
                        Image(data: data)
                    }
                }
            }
        }
        .onAppear { viewModel.onAppear() }
    }
}

struct ImageLoaderView_Previews: PreviewProvider {
    
    static let url = URL(string: "https://www.barefeetware.com/logo.png")!
    
    static var previews: some View {
        Group {
            ImageLoaderView(url: url)
            // For comparison:
            if #available(iOS 15.0, *) {
                AsyncImage(url: url) { image in
                    image
                        .background(Color.green)
                } placeholder: {
                    ProgressView()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
