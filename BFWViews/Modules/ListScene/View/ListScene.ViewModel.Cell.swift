//
//  ListScene.ViewModel.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ViewShowable {
    func view() -> any View
}

extension ListScene.ViewModel {
    public struct Cell: Identifiable, ViewShowable {
        private let base: Any
        private let _id: String
        private let _view: () -> any View
        private let listSceneViewModel: (() async -> ListScene.ViewModel)?
        
        public init<V: Identifiable & ViewShowable>(
            _ base: V,
            listSceneViewModel: (() async -> ListScene.ViewModel)? = nil
        ) where V.ID == String {
            self.base = base
            self._id = base.id
            self._view = base.view
            self.listSceneViewModel = listSceneViewModel
        }
        
        public var id: String {
            return _id
        }
        
        public func view() -> any View {
            return _view()
        }
    }
}
