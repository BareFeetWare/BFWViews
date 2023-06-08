//
//  Plan.DetailRow.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

public extension Plan {
    struct DetailRow: Identifiable {
        public let id: String
        public let title: String?
        public let subtitle: String?
        public let image: Plan.Image?
        public let trailingContent: (any View)?
    }
}

public extension Plan.DetailRow {
    
    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        image: Plan.Image? = nil,
        trailingContent: (any View)? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.trailingContent = trailingContent
    }
    
    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        image: Plan.Image? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.trailingContent = nil
    }
    
    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.trailingContent = trailing.map {
            Text($0)
                .multilineTextAlignment(.trailing)
        }
    }
    
}

extension Array where Element == Plan.DetailRow {
    static let preview: Self = [
        .init(
            title: "Title",
            subtitle: "Subtitle",
            trailing: "trailing",
            image: .init(
                source: .url(URL(string: "https://barefeetware.com/logo.png")!),
                width: 88
            )
        ),
        .init(
            title: "Title"
        ),
        .init(
            title: "Title",
            subtitle: "Subtitle",
            trailing: "trailing",
            image: .init(
                source: .system("person")
            )
        ),
    ]
}
