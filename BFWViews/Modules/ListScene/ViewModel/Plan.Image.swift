//
//  Plan.Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan {
    public struct Image {
        
        public init(
            source: Source,
            width: CGFloat? = nil,
            color: Color? = nil,
            cornerRadius: CGFloat = 0
        ) {
            self.source = source
            self.width = width
            self.color = color
            self.cornerRadius = cornerRadius
        }
        
        public let source: Source
        public let width: CGFloat?
        public let color: Color?
        public let cornerRadius: CGFloat
        
        public enum Source {
            case space
            case url(URL)
            case system(
                name: String,
                scale: SwiftUI.Image.Scale = .medium
            )
        }
    }
}

extension Plan.Image {
    
    public static func space(
        width: CGFloat? = nil
    ) -> Self {
        self.init(
            source: .space,
            width: width
        )
    }
    
    public static func url(
        _ url: URL,
        width: CGFloat? = nil,
        color: Color? = nil,
        cornerRadius: CGFloat
    ) -> Self {
        self.init(
            source: .url(url),
            width: width,
            color: color,
            cornerRadius: cornerRadius
        )
    }
    
    public static func system(
        name: String,
        scale: SwiftUI.Image.Scale = .medium,
        width: CGFloat? = nil,
        color: Color? = nil
    ) -> Self {
        .init(
            source: .system(name: name, scale: scale),
            width: width,
            color: color
        )
    }
}

extension Plan.Image {
    static let preview = Plan.Image(source: .url(URL(string: "https://www.barefeetware.com/logo.png")!))
}
