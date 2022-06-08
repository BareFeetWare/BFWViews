//
//  ReadFrame.swift
//
//  Created by Tom Brodhurst-Hill on 3/2/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func readFrame(
        in coordinateSpace: CoordinateSpace = .global,
        writer: @escaping (CGRect) -> Void
    ) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: FramePreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace)
                )
                .onPreferenceChange(FramePreferenceKey.self) {
                    writer($0)
                }
            }
        )
    }
}

private struct FramePreferenceKey: PreferenceKey {
    
    static let defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
    
}
