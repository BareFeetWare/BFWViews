//
//  ViewShowable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ViewShowable {
    func view() -> AnyView
}

public struct CellViewModel: Identifiable, ViewShowable {
    private let base: Any
    private let _id: UUID
    private let _view: () -> AnyView

    public init<V: Identifiable & ViewShowable>(_ base: V) where V.ID == UUID {
        self.base = base
        self._id = base.id
        self._view = base.view
    }

    public var id: UUID {
        return _id
    }

    public func view() -> AnyView {
        return _view()
    }
}
