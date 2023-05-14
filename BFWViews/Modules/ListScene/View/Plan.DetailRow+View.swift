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
                .frame(width: 60)
            VStack(alignment: .leading) {
                title.map { Text($0) }
                subtitle.map { Text($0) }
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            Spacer()
            trailing.map {
                Text("\($0)")
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct PlanDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        Plan.DetailRow.preview
    }
}
