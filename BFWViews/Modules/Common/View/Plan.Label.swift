//
//  Plan.Label.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public extension Plan {
    struct Label {
        let title: String
        let imageSymbol: ImageSymbol
        
        public init(_ title: String, imageSymbol: ImageSymbol) {
            self.title = title
            self.imageSymbol = imageSymbol
        }
    }
}

// MARK: - Views

extension Plan.Label: View {
    public var body: some View {
        SwiftUI.Label(title, systemImage: imageSymbol.name)
    }
}

// MARK: - Previews

#Preview {
    Plan.Label(
        "Hello, World!",
        imageSymbol: .exclamationmark
    )
}
