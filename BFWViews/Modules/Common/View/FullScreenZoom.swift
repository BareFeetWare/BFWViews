//
//  FullScreenZoom.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 17/7/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct FullScreenZoomView<Content: View>: View {
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    let content: () -> Content
    @State var isFullScreen = false
    
    public var body: some View {
        content()
            .fullScreenCover(isPresented: $isFullScreen) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    content()
                }
                .onTapGesture {
                    isFullScreen = false
                }
            }
            .onTapGesture {
                isFullScreen = true
            }
    }
}

struct FullScreenZoom: ViewModifier {
    @State var isFullScreen = true
    
    func body(content: Content) -> some View {
        // TODO: Make this work. For some reason, embedding this in a ViewModifier, the content does not appear in the fullscreenCover.
        FullScreenZoomView {
            content
        }
    }
}

extension View {
    func fullScreenZoomable() -> some View {
        modifier(FullScreenZoom())
    }
}

struct FullScreenZoom_Previews: PreviewProvider {
    
    private struct Preview: View {
        let image: Image = Image(systemName: "photo")
        let title: String = "Sample Title"
        
        var body: some View {
            List {
                HStack {
                    FullScreenZoomView {
                        imageView
                    }
                    .frame(maxWidth: 100)
                    Text("FullScreenZoomView")
                }
                HStack {
                    imageView
                        .fullScreenZoomable()
                        .frame(maxWidth: 100)
                    Text("fullScreenZoomable")
                }
            }
        }
        
        var imageView: some View {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.orange)
                .background(.white)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
