//
//  Plan.TextField.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 29/1/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan {
    public struct TextField {
        public let title: String
        @Binding public var text: String
        public let isSecure: Bool
        public let keyboardType: UIKeyboardType
        public let textContentType: UITextContentType?
        
        public init(
            _ title: String,
            text: Binding<String>,
            isSecure: Bool = false,
            keyboardType: UIKeyboardType = .default,
            textContentType: UITextContentType? = nil
        ) {
            self.title = title
            self._text = text
            self.isSecure = isSecure
            self.keyboardType = keyboardType
            self.textContentType = textContentType
        }
    }
}

// MARK: - Views

extension Plan.TextField: View {
    public var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .keyboardType(keyboardType)
        .textContentType(textContentType)
    }
}

// MARK: - Previews

#Preview {
    List {
        Plan.TextField("Title", text: .constant("Text"))
        Plan.TextField("Secure", text: .constant("Text"), isSecure: true)
    }
}
