//
//  DetailRow.swift
//
//  Created by Tom Brodhurst-Hill on 10/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI

extension Plan.DetailRow.Display: View {
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                viewModel.title.map { Text($0) }
                viewModel.subtitle.map { Text($0) }
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            Spacer()
            viewModel.trailing.map {
                Text("\($0)")
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct PlanDetailRowDisplay_Previews: PreviewProvider {
    static var previews: some View {
        Plan.DetailRow.Display(viewModel: .preview)
    }
}
