//
//  ReadFrame.swift
//
//  Created by Tom Brodhurst-Hill on 3/2/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

//  From BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension View {
    func readFrame(
        in coordinateSpace: CoordinateSpace = .global,
        writer: @escaping (CGRect) -> Void
    ) -> some View {
        modifier(ReadFrameModifier(coordinateSpace: coordinateSpace, writer: writer))
    }
}

// MARK: - Modifier

private struct ReadFrameModifier {
    let coordinateSpace: CoordinateSpace
    let writer: (CGRect) -> Void
    @State private var lastRoundedRect: CGRect?
}

// MARK: - Functions

extension ReadFrameModifier {
    
    /// Dedupes sub-pixel-jitter callbacks (e.g. 49.999… → 50.000…) that would otherwise call the writer on every layout pass — and that can cause an endless state-update / re-layout loop when the writer drives layout (e.g. animated cell heights derived from a measured natural size). Compares pixel-aligned copies but delivers the raw rect. The oscillation reproduces only on @3x hardware, never on Simulator, so a clean Simulator run is not evidence this guard can be removed.
    func onChange(frame rect: CGRect) {
        let roundedRect = rect.rounded
        guard roundedRect != lastRoundedRect else { return }
        lastRoundedRect = roundedRect
        writer(rect)
    }
    
}

// MARK: - Private Extensions

private extension CGRect {
    /// Pixel-aligned copy, for use in deduping geometry callbacks.
    var rounded: CGRect {
        CGRect(
            x: minX.rounded(),
            y: minY.rounded(),
            width: width.rounded(),
            height: height.rounded()
        )
    }
}

// MARK: - Views

extension ReadFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .backport.onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: coordinateSpace)
            } action: { rect in
                onChange(frame: rect)
            }
    }
}
