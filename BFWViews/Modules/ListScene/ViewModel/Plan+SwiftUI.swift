//
//  Plan+SwiftUI.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 15/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - View model implementations for basic SwiftUI components.

// Sorted alphabetically.

extension Plan {
    
    public struct Frame {
        public init(width: CGFloat? = nil, content: any View) {
            self.width = width
            self.content = content
        }
        
        public let width: CGFloat?
        public let content: any View
    }
    
    public struct HStack {
        public init(
            alignment: VerticalAlignment = .center,
            contents: [any View]
        ) {
            self.alignment = alignment
            self.contents = contents
        }
        
        public let alignment: VerticalAlignment
        public let contents: [any View]
    }
    
    public struct Picker {
        public init(title: String, options: [String], selection: String) {
            self.title = title
            self.options = options
            self.selection = selection
        }
        
        public let title: String
        public let options: [String]
        @State public var selection: String
    }
    
    public struct Slider {
        public init(range: ClosedRange<Double>, selection: Double = 0) {
            self.range = range
            self.selection = selection
        }
        
        public let range: ClosedRange<Double>
        @State public var selection: Double = 0
    }
    
    public struct Text {
        public init(_ string: String?) {
            self.string = string
        }
        
        let string: String?
    }
    
    public struct TextField {
        public init(title: String, text: String = "") {
            self.title = title
            self.text = text
        }
        
        public let title: String
        @State public var text: String = ""
    }
    
    public struct Toggle {
        public init(title: String, isOn: Bool = false) {
            self.title = title
            self.isOn = isOn
        }
        
        public let title: String
        @State public var isOn: Bool
    }
    
    public struct VStack {
        public init(
            alignment: HorizontalAlignment = .center,
            contents: [any View]
        ) {
            self.alignment = alignment
            self.contents = contents
        }
        
        public let alignment: HorizontalAlignment
        public let contents: [any View]
    }
    
}
