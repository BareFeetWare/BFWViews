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
    
    public init(url: URL) {
        self.init(source: .url(url))
    }
    
    public init(systemImageName: String) {
        self.init(source: .system(systemImageName))
    }
}

extension Plan.Image {
    static let preview = Plan.Image(source: .url(URL(string: "https://www.barefeetware.com/logo.png")!))
}
