//
//  Boss.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Boss {
    public struct Cell: Identifiable, ViewShowable {
        public let base: Any
        public let _id: String
        public let _view: () -> AnyView
        public let listSceneViewModel: (() async -> ListScene.ViewModel)?
        
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
        
        public func view() -> AnyView {
            return _view()
        }
    }
}

// MARK: - Static instances of Cell. Add your own custom instances in your project.

public extension Boss.Cell {
    
    static func detail(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        listSceneViewModel: (() async -> ListScene.ViewModel)? = nil
    ) -> Self {
        .init(
            DetailCell.ViewModel(
                title: title,
                subtitle: subtitle,
                trailing: trailing
            ),
            listSceneViewModel: listSceneViewModel
        )
    }
    
    static func button(_ title: String, action: @escaping () -> Void) -> Self {
        .init(Boss.Button(title: title, action: action))
    }
    
    static func image(url: URL) -> Self {
        .init(Boss.Image(url: url))
    }
    
}
