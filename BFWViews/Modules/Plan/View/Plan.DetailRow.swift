//
//  Plan.DetailRow.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Plan {
    struct DetailRow: OptionalIdentifiable, Titled {
        public let id: String?
        public let title: String
        public let subtitle: String?
        public let trailing: String?
        public let image: Plan.Image?
        
        public init(
            id: String? = nil,
            title: String,
            subtitle: String? = nil,
            trailing: String? = nil,
            image: Plan.Image? = nil
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.image = image
            self.trailing = trailing
        }
    }
}

// MARK: - Convenience Inits

public extension Plan.DetailRow {
    
    init(_ title: String, id: String? = nil, subtitle: String? = nil, trailing: String? = nil) {
        self.init(id: id, title: title, subtitle: subtitle, trailing: trailing)
    }
    
}

// MARK: - Functions

public extension Plan.DetailRow {
    
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

// MARK: - Views

extension Plan.DetailRow: View {
    public var body: some View {
        HStack {
            image
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                subtitle.map { Text($0) }
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            Spacer()
            // Note: On iOS 13 - 15?, using a Spacer() here instead of frame, causes a containing Menu to show multiple rows per row. Weird.
            // Alternatively, use frame, but spacing is too wide:
            //.frame(maxWidth: .infinity, alignment: .leading)
            trailing.map {
                Text($0)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension Array where Element == Plan.DetailRow {
    var body: some View {
        ForEach(self.identified()) { $0 }
    }
}

// MARK: - Previews

private extension Array where Element == Plan.DetailRow {
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

struct PlanDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                [Plan.DetailRow].preview.body
            }
            .navigationTitle("Plan.DetailRow")
        }
    }
}
