//
//  IdentifiableText.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/9/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public struct IdentifiableText: Identifiable {
    public let title: String
    
    public init(_ title: String) {
        self.title = title
    }
    
    public var id: String { title }
}

// MARK: - Views

extension IdentifiableText: View {
    public var body: some View {
        Text(title)
    }
}

#Preview {
    IdentifiableText("Unique string here")
}
