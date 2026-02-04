//
//  LabeledContent.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 21/1/2026.
//

import SwiftUI

/// Backward compatibility implementation.
public struct LabeledContent<Content: View> {
    public let titleKey: LocalizedStringKey
    public let content: () -> Content
    
    public init(_ titleKey: LocalizedStringKey, content: @escaping () -> Content) {
        self.titleKey = titleKey
        self.content = content
    }
    
    public init(_ title: String, content: @escaping () -> Content) {
        self.titleKey = LocalizedStringKey(title)
        self.content = content
    }
}

// MARK: - Views

extension LabeledContent: View {
    public var body: some View {
        if #available(iOS 16.0, *) {
            SwiftUI.LabeledContent(titleKey, content: content)
        } else {
            HStack {
                Text(titleKey)
                    .multilineTextAlignment(.leading)
                Spacer()
                content()
            }
        }
    }
}
