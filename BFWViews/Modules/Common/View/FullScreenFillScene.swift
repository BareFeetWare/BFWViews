//
//  FullScreenFillScene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 17/7/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct FullScreenFillScene<Content: View>: View {
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    let content: () -> Content
    @State var isFullScreen = false
    
    func onTapClose() {
        isFullScreen = false
    }
    
    func onTapSmall() {
        isFullScreen = true
    }
    
    public var body: some View {
        content()
            .onTapGesture {
                onTapSmall()
            }
            .fullScreenCover(isPresented: $isFullScreen) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    content()
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        onTapClose()
                    } label: {
                        Plan.Image(source: .system(symbol: .xmark, scale: .large))
                            .foregroundColor(.primary)
                            .colorScheme(.dark)
                    }
                    .padding()
                }
            }
    }
}

struct FullScreenFillSceneModifier: ViewModifier {
    @State var isFullScreen = true
    
    func body(content: Content) -> some View {
        // TODO: Make this work. For some reason, embedding this in a ViewModifier, the content does not appear in the fullscreenCover.
        FullScreenFillScene {
            content
        }
    }
}

extension View {
    func fullScreenFillScene() -> some View {
        modifier(FullScreenFillSceneModifier())
    }
}

// MARK: - Previews

struct FullScreenFillScene_Previews: PreviewProvider {
    
    private struct Preview: View {
        let image: Image = Image(systemName: "photo")
        let title: String = "Sample Title"
        
        var body: some View {
            List {
                HStack {
                    FullScreenFillScene {
                        ZoomView {
                            imageView
                        }
                    }
                    .frame(maxWidth: 100)
                    Text("FullScreenZoomView")
                }
                HStack {
                    imageView
                        .fullScreenFillScene()
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
