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
        public let detailRow: Plan.DetailRow
        @Binding public var text: String
        public let isSecure: Bool
        public let keyboardType: UIKeyboardType
        public let textContentType: UITextContentType?
        
        public init(
            _ detailRow: Plan.DetailRow,
            text: Binding<String>,
            isSecure: Bool = false,
            keyboardType: UIKeyboardType = .default,
            textContentType: UITextContentType? = nil
        ) {
            self.detailRow = detailRow
            self._text = text
            self.isSecure = isSecure
            self.keyboardType = keyboardType
            self.textContentType = textContentType
        }
    }
}

// MARK: - Functions

public extension Plan.TextField {
    
    var title: String {
        detailRow.title
    }
    
}

// MARK: - Convenience Inits

public extension Plan.TextField {
    
    init(
        _ title: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) {
        self.init(
            .init(title),
            text: text,
            isSecure: isSecure,
            keyboardType: keyboardType,
            textContentType: textContentType,
        )
    }
    
}

// MARK: - Views

extension Plan.TextField: View {
    public var body: some View {
        Group {
            if isSecure {
                SecureField(text: $text) { detailRow }
            } else {
                TextField(text: $text) { detailRow }
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
