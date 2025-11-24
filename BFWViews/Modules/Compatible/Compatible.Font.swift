//
//  Compatible.Font.swift
//
//  Created by Tom Brodhurst-Hill on 23/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Compatible {
    public enum Font {}
}

extension Compatible.Font {
    public enum Width {
        case expanded, compressed, condensed, standard
        
        @available(iOS 16.0, *)
        var actual: Font.Width {
            switch self {
            case .compressed: .compressed
            case .condensed: .condensed
            case .expanded: .expanded
            case .standard: .standard
            }
        }
    }
}

public extension View {
    
    @ViewBuilder
    func ifAvailableFontWeight(_ weight: Font.Weight) -> some View {
        if #available(iOS 16.0, *) {
            self.fontWeight(weight)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifAvailableFontWidth(_ width: Compatible.Font.Width) -> some View {
        if #available(iOS 16.0, *) {
            self.fontWidth(width.actual)
        } else {
            self
        }
    }
    
}
