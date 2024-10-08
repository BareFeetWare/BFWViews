//
//  Plan.DetailRow.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation

public extension Plan {
    struct DetailRow: Identifiable {
        public let id: String
        public let title: String?
        public let subtitle: String?
        public let trailing: String?
        public let image: Plan.Image?
    }
}

public extension Plan.DetailRow {
    
    init(
        id: String? = nil,
        title: String?,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.trailing = trailing
    }
    
    func withImageWidth(_ width: CGFloat?) -> Self {
        .init(
            id: id,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            image: image?.withWidth(width)
        )
    }
    
}

extension Array where Element == Plan.DetailRow {
    static let preview: Self = [
        .init(
            title: "Title",
            subtitle: "Subtitle",
            trailing: "trailing",
            image: .init(
                source: .url(URL(string: "https://barefeetware.com/logo.png")!, caching: .none),
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
                source: .system(symbol: .person)
            )
        ),
        .init(
            title: "Long title that wraps over a few lines to see how spacing adjusts",
            subtitle: "Subtitle",
            trailing: "Long trailing text that wraps over a few lines to force spacing",
            image: .init(
                source: .system(symbol: .person)
            )
        ),
        .init(
            title: "Short title",
            trailing: "Long trailing text that wraps over a few lines to force spacing",
            image: .init(
                source: .system(symbol: .person)
            )
        ),
    ]
}
