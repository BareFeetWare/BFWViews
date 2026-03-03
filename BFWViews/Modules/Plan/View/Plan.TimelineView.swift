//
//  Plan.TimelineView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/3/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct TimelineView<Content> {
        let timeInterval: TimeInterval
        let content: () -> Content
        
        init(timeInterval: TimeInterval, content: @escaping () -> Content) {
            self.timeInterval = timeInterval
            self.content = content
        }
    }
}

// MARK: - Views

extension Plan.TimelineView: View where Content: View {
    public var body: some View {
        TimelineView(
            .periodic(from: .now, by: timeInterval),
            content: { _ in content() }
        )
    }
}

// MARK: - Previews

#Preview {
    Plan.TimelineView(timeInterval: 2) {
        Text(String(describing: Date()))
    }
}
