//
//  WithAnimation+Compatible.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 16/3/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Compatibility bridge for `withAnimation(_:completionCriteria:_:completion:)` which requires iOS 17.
/// On iOS 17+, calls the native `withAnimation` with completion.
/// On earlier versions, falls back to `DispatchQueue.main.asyncAfter` with an arbitrary 0.5s delay,
/// which may not match the actual animation duration.
public func compatibleWithAnimation<Result>(
    _ animation: Animation? = .default,
    _ body: () throws -> Result,
    completion: @escaping () -> Void
) rethrows -> Result {
    if #available(iOS 17.0, *) {
        return try withAnimation(animation, body, completion: completion)
    } else {
        let result = try withAnimation(animation, body)
        let duration = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
        return result
    }
}
