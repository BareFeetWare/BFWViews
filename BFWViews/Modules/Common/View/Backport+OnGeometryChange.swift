//
//  Backport+OnGeometryChange.swift
//
//  Created by Tom Brodhurst-Hill on 20/7/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

//  From BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension Backport where Wrapped: View {
    /// Backport of iOS 16+'s `View.onGeometryChange(for:of:action:)` to iOS 15, with the same signature. On iOS 16+, forwards to Apple's implementation. On iOS 15, uses a `GeometryReader` + `PreferenceKey` fallback with the same measurement characteristics as the pre-backport `readFrame` (including its inability to measure composite content inside UIKit-hosted list cells — the reason the iOS 16 primary path exists).
    func onGeometryChange<T: Equatable>(
        for type: T.Type,
        of transform: @escaping (GeometryProxy) -> T,
        action: @escaping (T) -> Void
    ) -> some View {
        wrapped.modifier(OnGeometryChangeModifier(transform: transform, action: action))
    }
}

// MARK: - Modifier

private struct OnGeometryChangeModifier<T: Equatable> {
    let transform: (GeometryProxy) -> T
    let action: (T) -> Void
}

extension OnGeometryChangeModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.onGeometryChange(for: T.self, of: transform, action: action)
        } else {
            content.modifier(FallbackModifier(transform: transform, action: action))
        }
    }
}

// MARK: - Fallback

private struct FallbackModifier<T: Equatable> {
    let transform: (GeometryProxy) -> T
    let action: (T) -> Void
}

extension FallbackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: FallbackPreferenceKey<T>.self,
                            value: transform(geometry)
                        )
                }
            )
            .onPreferenceChange(FallbackPreferenceKey<T>.self) { value in
                if let value {
                    action(value)
                }
            }
    }
}

// MARK: - Private Extensions

private struct FallbackPreferenceKey<T: Equatable>: PreferenceKey {
    static var defaultValue: T? { nil }
    static func reduce(value: inout T?, nextValue: () -> T?) {
        value = nextValue() ?? value
    }
}
