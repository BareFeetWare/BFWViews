//
//  Plan.LabeledContent.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/2/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct LabeledContent<Label, Content> {
        public let label: Label
        public let content: Content
    }
}

extension Plan.LabeledContent: View where Label: View, Content: View {
    public var body: some View {
        LabeledContent {
            content
                .multilineTextAlignment(.trailing)
        } label: {
            label
        }
    }
}
