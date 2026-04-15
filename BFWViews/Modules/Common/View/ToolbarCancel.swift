//
//  ToolbarCancel.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 16/4/26.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func toolbarCancel(action: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Plan.Button("Cancel", systemImage: "xmark", role: .cancel) {
                    action()
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("ToolbarCancel") {
    NavigationStack {
        Text("Content")
            .toolbarCancel {}
    }
}
