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
        public var isExpanded: Binding<Bool>? = nil
        public let header: (() -> any View)?
        public var cells: [Cell?]
        public var emptyPlaceholder: String?
    }
}

public extension Plan.Section {
    
    init(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        header: (() -> any View)?,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
    ) {
        self.init(
            id: id ?? UUID().uuidString,
            isExpanded: isExpanded,
            header: header,
            cells: cells,
            emptyPlaceholder: emptyPlaceholder
        )
    }
    
    init(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        title: String? = nil,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
    ) {
        self.init(
            id: id,
            isExpanded: isExpanded,
            header: title.map { title in
                {
                    Text(title)
                        .textCase(.none)
                }
            },
            cells: cells,
            emptyPlaceholder: emptyPlaceholder
        )
    }
    
    init(
        id: String? = nil,
        placeholder: String
    ) {
        self.init(
            id: id,
            header: {
                Text(placeholder)
                    .textCase(.none)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            },
            cells: []
        )
    }
    
    init<T: View>(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        title: String? = nil,
        trailing: @escaping () -> T,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
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
            cells: cells,
            emptyPlaceholder: emptyPlaceholder
        )
    }
    
    var rowPlaceholderString: String? {
        guard let emptyPlaceholder, cells.isEmpty
        else { return nil }
        return emptyPlaceholder
    }
    
}
