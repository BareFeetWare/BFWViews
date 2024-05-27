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
    
    // TODO: Consolidate/merge some of the following inits.
    
    init(
        id: String,
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
        isExpanded: Binding<Bool>? = nil,
        title: String? = nil,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
    ) {
        self.init(
            // TODO: Centralise UUID.
            id: title.map { "title: " + $0 } ?? UUID().uuidString,
            isExpanded: isExpanded,
            header: {
                title.map {
                    Text($0)
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
            id: id ?? "placeholder: " + placeholder,
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
        id: String,
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

    init<T: View>(
        id: String? = nil,
        isExpanded: Binding<Bool>? = nil,
        title: String,
        trailing: @escaping () -> T,
        cells: [Plan.Cell?],
        emptyPlaceholder: String? = nil
    ) {
        self.init(
            id: id ?? "title: " + title,
            isExpanded: isExpanded,
            header: {
                HStack {
                    Text(title)
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
