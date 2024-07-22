//
//  OnTapFullScreenCover.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 17/7/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

extension View {
    func onTapFullScreenCover<Cover: View>(
        _ cover: @escaping () -> Cover
    ) -> some View {
        modifier(OnTapFullScreenCoverModifier(cover: cover))
    }
}

struct OnTapFullScreenCoverModifier<Cover: View>: ViewModifier {
    
    let cover: () -> Cover
    @State var isPresented = false
    
    func onTapClose() {
        isPresented = false
    }
    
    func onTapSmall() {
        isPresented = true
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                onTapSmall()
            }
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    cover()
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

// MARK: - Previews

struct OnTapFullScreenCoverModifier_Previews: PreviewProvider {
    
    private struct Preview: View {
        let image: Image = Image(systemName: "photo")
        let title: String = "Sample Title"
        
        var body: some View {
            List {
                HStack {
                    imageView
                        .onTapFullScreenCover {
                            ZoomView {
                                imageView
                            }
                        }
                        .frame(maxWidth: 100)
                    Text(".onTapFullScreenCover()")
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
