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
            color: Color? = nil
        ) {
            self.source = source
            self.width = width
            self.color = color
        }
        
        public let source: Source
        public let width: CGFloat?
        public let color: Color?
        
        public enum Source {
            case space
            case url(URL)
            case system(String)
        }
    }
}

extension Plan.Image {
    
    public static let space: Self = .init(source: .space)
    
    public static func url(
        _ url: URL,
        width: CGFloat? = nil,
        color: Color? = nil
    ) -> Self {
        self.init(
            source: .url(url),
            width: width,
            color: color
        )
    }
    
    public static func system(
        imageName: String,
        width: CGFloat? = nil,
        color: Color? = nil
    ) -> Self {
        .init(
            source: .system(imageName),
            width: width,
            color: color
        )
    }
}

extension Plan.Image {
    static let preview = Plan.Image(source: .url(URL(string: "https://www.barefeetware.com/logo.png")!))
}
