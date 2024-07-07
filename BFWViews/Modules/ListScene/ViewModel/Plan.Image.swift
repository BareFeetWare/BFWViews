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
            foregroundColor: Color? = nil,
            backgroundColor: Color? = nil,
            cornerRadius: CGFloat = 0
        ) {
            self.source = source
            self.width = width
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
        }
        
        public let source: Source
        public let width: CGFloat?
        public let foregroundColor: Color?
        public let backgroundColor: Color?
        public let cornerRadius: CGFloat
        
        public enum Source {
            case space
            case uiImage(UIImage)
            case url(URL, caching: Fetch.Caching)
            case system(
                symbol: ImageSymbol,
                variants: SymbolVariants = .none,
                scale: SwiftUI.Image.Scale = .medium
            )
        }
    }
}

public extension Plan.Image {
    
    static func space(
        width: CGFloat? = nil
    ) -> Self {
        self.init(
            source: .space,
            width: width
        )
    }
    
    static func url(
        _ url: URL,
        caching: Fetch.Caching,
        width: CGFloat? = nil,
        foregroundColor: Color? = nil,
        cornerRadius: CGFloat = 0
    ) -> Self {
        self.init(
            source: .url(url, caching: caching),
            width: width,
            foregroundColor: foregroundColor,
            cornerRadius: cornerRadius
        )
    }
    
    static func system(
        symbol: ImageSymbol,
        variants: SymbolVariants = .none,
        scale: SwiftUI.Image.Scale = .medium,
        width: CGFloat? = nil,
        foregroundColor: Color? = nil
    ) -> Self {
        .init(
            source: .system(
                symbol: symbol,
                variants: variants,
                scale: scale
            ),
            width: width,
            foregroundColor: foregroundColor
        )
    }
    
    func withWidth(_ width: CGFloat?) -> Self {
        .init(
            source: source,
            width: width,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        )
    }
    
}

extension Plan.Image {
    static let preview = Plan.Image(
        source: .url(
            URL(string: "https://www.barefeetware.com/logo.png")!,
            caching: .file
        )
    )
}
