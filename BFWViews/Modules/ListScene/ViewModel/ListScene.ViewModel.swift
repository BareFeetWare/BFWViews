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
                // TODO: Perhaps instead use subscriber.
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.isActiveDestination = self.destinationViewModel != nil
                }
            }
        }
        @Published var isActiveDestination = false
    }
}

// MARK: - Types

public extension ListScene.ViewModel {
    
    struct Section: Identifiable {
        public let id: String
        let title: String?
        var cells: [Cell]
    }
    
    enum Cell: Identifiable {
        case button(Button)
        case detail(DetailCell.ViewModel)
        case push(DetailCell.ViewModel, () async -> ListScene.ViewModel)
        
        public var id: String {
            switch self {
            case .detail(let detailCellViewModel), .push(let detailCellViewModel, _):
                // TODO: Better nil handling.
                return detailCellViewModel.id
            case .button(let button):
                return button.title
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
    public init(
        title: String? = nil,
        cells: [ListScene.ViewModel.Cell]
    ) {
        self.id = UUID().uuidString
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
                .init(cells: cells)
            ]
        )
    }
    
}

public extension ListScene.ViewModel.Section {
    
    init(
        _ title: String?,
        cells: [ListScene.ViewModel.Cell]
    ) {
        self.id = UUID().uuidString
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
    
    func action(
        destinationSceneViewModel: @escaping () async -> ListScene.ViewModel
    ) -> (() -> Void)? {
        {
            DispatchQueue.main.async {
                Task {
                    self.destinationViewModel = await destinationSceneViewModel()
                }
            }
        }
    }
}

// MARK: - Previews

extension ListScene.ViewModel {
    static let preview: ListScene.ViewModel = .init(
        title: "List Scene Root",
        sections: [
            Section(
                title: "Buttons and detail",
                cells: [
                    .button(
                        .init(title: "Start", action: {})
                    ),
                    .detail(
                        .init(title: "Status", trailing: "Off line")
                    ),
                    .button(
                        .init(title: "Scan", action: {})),
                ]
            ),
            Section(
                title: "Async children",
                cells: [
                    .push(
                        .init(title: "Children", trailing: "23"),
                        childrenSceneViewModel
                    ),
                ]
            ),
        ]
    )
    
    static func childrenSceneViewModel() async -> ListScene.ViewModel {
        // Arbitrary delay, pretending to be an async request.
        try? await Task.sleep(nanoseconds: 2000000000)
        let children = ["Child 1", "Child 2", "Child 3"]
        return .init(
            title: "Children",
            cells: children.map { child in
                    .detail(.init(title: child))
            }
        )
    }
    
}
