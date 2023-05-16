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
        public let trailing: String?
        public let image: Plan.Image?
        public let imageWidth: CGFloat?
        public let trailingContent: (any View)?
    }
}

public extension Plan.DetailRow {
    init(
        id: String? = nil,
        title: String,
        subtitle: String? = nil,
        trailing: String? = nil,
        image: Plan.Image? = nil,
        imageWidth: CGFloat? = nil,
        trailingContent: (any View)? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
        self.image = image
        self.imageWidth = imageWidth
        self.trailingContent = trailingContent
    }
}

extension Plan.DetailRow {
    static let preview: Self = .init(
        title: "Title",
        subtitle: "Subtitle",
        trailing: "trailing",
        image: .init(source: .url(URL(string: "https://barefeetware.com/logo.png")!))
    )
}
