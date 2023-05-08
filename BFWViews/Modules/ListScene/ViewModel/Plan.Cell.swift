//
//  Plan.Cell.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Cell: Identifiable {
        public let id: String
        public let viewModel: any ViewShowable
        public let destination: (() async -> any ViewShowable)?
        
        public init(
            id: String = UUID().uuidString,
            viewModel: any ViewShowable,
            destination: (() async -> any ViewShowable)? = nil
        ) {
            self.id = id
            self.viewModel = viewModel
            self.destination = destination
        }
        
    }
}

// MARK: - Static instances of Cell. Add your own custom instances in your project.

public extension Plan.Cell {
    
    static func detail(
        _ title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        destination: (() async -> any ViewShowable)? = nil
    ) -> Self {
        .init(
            viewModel: Plan.DetailRow(
                title: title,
                subtitle: subtitle,
                trailing: trailing
            ),
            destination: destination
        )
    }
    
    static func button(_ title: String, action: @escaping () -> Void) -> Self {
        .init(viewModel: Plan.Button(title: title, action: action))
    }
    
    static func image(url: URL) -> Self {
        .init(viewModel: Plan.Image(url: url))
    }
    
}
