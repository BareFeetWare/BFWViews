//
//  LabeledContent.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 21/1/2026.
//

import SwiftUI

/// Backward compatibility implementation.
public struct LabeledContent<Content, Label> {
    public let content: () -> Content
    public let label: () -> Label

    public init(
        content: @escaping () -> Content,
        label: @escaping () -> Label
    ) {
        self.content = content
        self.label = label
    }
    
    public init(
        _ titleKey: LocalizedStringKey,
        content: @escaping () -> Content
    ) where Label == Text {
        self.label = { Text(titleKey) }
        self.content = content
    }
    
    public init(
        _ title: String,
        content: @escaping () -> Content
    ) where Label == Text {
        self.label = { Text(title) }
        self.content = content
    }
}

// MARK: - Views

extension LabeledContent: View where Content: View, Label: View {
    public var body: some View {
        if #available(iOS 16.0, *) {
            SwiftUI.LabeledContent(content: content, label: label)
        } else {
            HStack {
                label()
                    .multilineTextAlignment(.leading)
                Spacer()
                content()
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}
