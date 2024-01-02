//
//  Plan.Section.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan {
    public struct Section: Identifiable {
        public let id: String
        var isExpanded: Binding<Bool>? = nil
        public let header: (() -> any View)?
        public var cells: [Cell?]
    }
}

public extension Plan.Section {

    init(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        header: (() -> any View)?,
        cells: [Plan.Cell?]
    ) {
        self.init(
            id: id ?? UUID().uuidString,
            isExpanded: isExpanded,
            header: header,
            cells: cells
        )
    }
    
    init(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        title: String? = nil,
        cells: [Plan.Cell?]
    ) {
        self.init(
            id: id,
            isExpanded: isExpanded,
            header: title.map { title in
                {
                    Text(title)
                }
            },
            cells: cells
        )
    }
    
    init<T: View>(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        title: String? = nil,
        trailing: @escaping () -> T,
        cells: [Plan.Cell?]
    ) {
        self.init(
            id: id,
            isExpanded: isExpanded,
            header: {
                HStack {
                    title.map { Text($0) }
                    Spacer()
                    trailing()
                }
            },
            cells: cells
        )
    }
    
}
