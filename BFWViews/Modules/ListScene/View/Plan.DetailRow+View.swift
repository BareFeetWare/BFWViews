//
//  Plan.DetailRow+View.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 27/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.DetailRow: View {
    public var body: some View {
        HStack {
            image
            VStack(alignment: .leading, spacing: 4) {
                title.map { Text($0) }
                subtitle.map { Text($0) }
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            // Note: Using a Spacer() here instead of frame, causes a containing Menu to show multiple rows per row. Weird.
            .frame(maxWidth: .infinity, alignment: .leading)
            AnyView(trailingContent())
                .multilineTextAlignment(.trailing)
        }
    }
}

struct PlanDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach([Plan.DetailRow].preview) { $0 }
        }
        .previewLayout(.sizeThatFits)
    }
}
