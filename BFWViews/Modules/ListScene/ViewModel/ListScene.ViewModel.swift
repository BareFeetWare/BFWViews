//
//  ListScene.ViewModel.swift
//
//  Created by Tom Brodhurst-Hill on 19/4/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import Foundation

public extension ListScene {
    class ViewModel: ObservableObject {
        
        public init(
            title: String,
            sections: [Section]
        ) {
            self.title = title
            self.sections = sections
        }
        
        public let title: String
        @Published public var sections: [Section]
        @Published public var destinationViewModel: ListScene.ViewModel? {
            didSet {
                isActiveDestination = destinationViewModel != nil
            }
        }
        @Published var isActiveDestination = false
    }
}

// MARK: - Types

public extension ListScene.ViewModel {
    
    struct Section: Identifiable {
        let title: String?
        var cells: [Cell]
        
        public var id: String { title ?? "nil" }
    }
    
    enum Cell: Identifiable {
        case button(Button)
        case detail(Detail)
        
        public var id: String {
            switch self {
            case .button(let button): return "button(title: \(button.title))"
            case .detail(let detail): return "detail(id: \(detail.id))"
            }
        }
        
        public struct Detail {
            public let id: String
            public let detailCellViewModel: DetailCell.ViewModel
            public var onTap: (() -> Void)?
            
            public init(
                _ title: String?,
                id: String? = nil,
                subtitle: String? = nil,
                trailing: String? = nil,
                onTap: (() -> Void)? = nil
            ) {
                self.id = id ?? title ?? "nil"
                self.detailCellViewModel = .init(title: title, subtitle: subtitle, trailing: trailing)
                self.onTap = onTap
            }
        }
        
    }
    
    struct Button {
        let title: String
        let action: () -> Void
        
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
    
}

// MARK: - Public Inits

extension ListScene.ViewModel.Section {
    public init(title: String, cells: [ListScene.ViewModel.Cell]) {
        self.title = title
        self.cells = cells
    }
}

// MARK: - Convenience Inits

public extension ListScene.ViewModel {
    
    convenience init(
        title: String,
        cells: [Cell]
    ) {
        self.init(
            title: title,
            sections: [
                .init(
                    title: nil,
                    cells: cells
                )
            ]
        )
    }
    
}

public extension ListScene.ViewModel.Section {
    
    init(
        _ title: String?,
        cells: [ListScene.ViewModel.Cell]
    ) {
        self.title = title
        self.cells = cells
    }
    
}

// MARK: - Public Functions

public extension ListScene.ViewModel {
    
    func update(cell: Cell) {
        for (sectionIndex, section) in sections.enumerated() {
            guard let cellIndex = section.cells.firstIndex(where: { $0.id == cell.id })
            else { continue }
            sections[sectionIndex].cells[cellIndex] = cell
        }
    }
    
}

// MARK: - Previews

extension ListScene.ViewModel {
    static let preview: ListScene.ViewModel = .init(
        title: "Bluetooth",
        sections: [
            Section(
                title: "Bluetooth Central Manager",
                cells: [
                    .button(
                        .init(title: "Start", action: {})
                    ),
                    .detail(
                        .init("Status", trailing: "Off line")
                    ),
                    .button(
                        .init(title: "Scan", action: {})),
                ]
            ),
            Section(
                title: "Devices",
                cells: [
                    .detail(
                        .init("Peripherals", trailing: "23")
                    ),
                ]
            ),
        ]
    )
}
