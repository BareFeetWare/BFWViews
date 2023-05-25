//
//  Plan.Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation

extension Plan {
    public struct Image {
        public let source: Source
        
        public enum Source {
            case space
            case url(URL)
            case system(String)
        }
    }
}

extension Plan.Image {
    
    public static let space: Self = .init(source: .space)
    
    public static func url(_ url: URL) -> Self {
        self.init(source: .url(url))
    }
    
    public static func system(imageName: String) -> Self {
        .init(source: .system(imageName))
    }
}

extension Plan.Image {
    static let preview = Plan.Image(source: .url(URL(string: "https://www.barefeetware.com/logo.png")!))
}
