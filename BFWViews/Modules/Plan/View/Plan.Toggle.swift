//
//  Plan.Toggle.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/9/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct Toggle {
        public let detailRow: Plan.DetailRow
        @Binding public var isOn: Bool
    }
}

// MARK: - Convenience Inits

public extension Plan.Toggle {
    
    init(
        _ detailRow: Plan.DetailRow,
        isOn: Binding<Bool>
    ) {
        self.detailRow = detailRow
        self._isOn = isOn
    }
    
    init(
        _ title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.detailRow = .init(title: title, subtitle: subtitle)
        self._isOn = isOn
    }
    
}

// MARK: - Views

extension Plan.Toggle: View {
    public var body: some View {
        Toggle(isOn: $isOn) {
            detailRow
        }
    }
}

// MARK: - Previews

private struct Toggle_Previews: PreviewProvider {
    
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        @State var isOn = false
        
        var body: some View {
            List {
                Plan.Toggle(
                    "Toggle",
                    isOn: $isOn
                )
            }
        }
    }
}
