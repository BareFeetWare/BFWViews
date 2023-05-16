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
        public let content: any View
        public let destination: (() async -> any View)?
        
        public init(
            id: String = UUID().uuidString,
            content: any View,
            destination: (() async -> any View)? = nil
        ) {
            self.id = id
            self.content = content
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
        image: Plan.Image? = nil,
        imageWidth: CGFloat? = nil,
        trailingContent: (any View)? = nil,
        destination: (() async -> any View)? = nil
    ) -> Self {
        .init(
            content: Plan.DetailRow(
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                image: image,
                imageWidth: imageWidth,
                trailingContent: trailingContent
            ),
            destination: destination
        )
    }
    
    static func button(_ title: String, action: @escaping () -> Void) -> Self {
        .init(content: Plan.Button(title: title, action: action))
    }
    
    static func image(url: URL) -> Self {
        .init(content: Plan.Image(url: url))
    }
    
}
