//
//  IdentifiableText.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/9/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

struct IdentifiableText: Identifiable {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var id: String { title }
}

// MARK: - Views

extension IdentifiableText: View {
    var body: some View {
        Text(title)
    }
}

#Preview {
    IdentifiableText("Unique string here")
}
