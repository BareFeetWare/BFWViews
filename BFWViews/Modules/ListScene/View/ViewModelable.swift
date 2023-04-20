//
//  ViewModelable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ViewModelViewFactory {
    associatedtype View: SwiftUI.View
    func createView() -> View
}

public protocol AnyViewModel: Identifiable, ViewModelViewFactory {
    var id: String { get }
}

public struct AnyViewFactory: Identifiable {
    public let id: String
    public let createView: () -> AnyView

    public init<V: AnyViewModel>(_ viewModel: V) {
        id = viewModel.id
        createView = { AnyView(viewModel.createView()) }
    }
}
