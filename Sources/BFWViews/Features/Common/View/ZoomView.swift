//
//  ZoomView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 22/7/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

struct ZoomView<Content: View> {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func onChangedMagnification(value: CGFloat) {
        scale = value
    }
    
    func onEndedMagnification(value: CGFloat) {
        withAnimation {
            if scale < 1 {
                scale = 1
                offset = .zero
                lastOffset = .zero
            }
        }
    }
    
    func onChangedDragGesture(value: DragGesture.Value) {
        offset = CGSize(
            width: value.translation.width + lastOffset.width,
            height: value.translation.height + lastOffset.height
        )
    }
    
    func onEndedDragGesture(value: DragGesture.Value) {
        lastOffset = offset
    }
    
}

extension ZoomView: View {
    var body: some View {
        content
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { onChangedMagnification(value: $0) }
                        .onEnded { onEndedMagnification(value: $0) },
                    DragGesture()
                        .onChanged { onChangedDragGesture(value: $0) }
                        .onEnded { onEndedDragGesture(value: $0) }
                )
            )
    }
}
