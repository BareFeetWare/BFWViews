//
//  Backport.swift
//
//  Created by Tom Brodhurst-Hill on 20/7/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

//  From BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

/// Namespace for shims of framework APIs whose deployment floor is above ours. Shim methods keep the framework's own name, so call sites read `.backport.someModifier(...)`, greppable by the framework name, and migration off a shim is deleting `.backport` once the deployment target reaches the API's floor.
public struct Backport<Wrapped> {
    public let wrapped: Wrapped
}

public extension View {
    var backport: Backport<Self> { Backport(wrapped: self) }
}
