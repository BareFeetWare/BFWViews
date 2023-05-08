//
//  ViewShowable.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 20/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

// MARK: - View models

extension Plan {
    
    struct FirstRow {
        // Implement view model content here.
        
        struct Display {
            let viewModel: FirstRow
        }
    }
    
    struct SecondRow {
        // Implement view model content here.
        
        struct Display {
            let viewModel: SecondRow
        }
    }
    
    struct RootScene {
        let cells: [Cell] = [
            .init(viewModel: Plan.FirstRow()),
            .init(viewModel: Plan.SecondRow()),
        ]
        
        struct Display {
            let viewModel: RootScene
        }
    }
}

// MARK: - Views

extension Plan.FirstRow.Display: View {
    var body: some View {
        Text("FirstRow View")
        // Implement the view content here, using the view model.
    }
}

extension Plan.SecondRow.Display: View {
    var body: some View {
        Text("SecondScene View")
        // Implement the view content here, using the view model.
    }
}

extension Plan.FirstRow: ViewShowable {
    func view() -> some View {
        Display(viewModel: self)
    }
}

extension Plan.SecondRow: ViewShowable {
    func view() -> some View {
        Display(viewModel: self)
    }
}


extension Plan.RootScene.Display: View {
    var body: some View {
        List {
            ForEach(viewModel.cells) { cell in
                AnyView(cell.viewModel.view())
            }
        }
    }
}

struct ViewShowableScene: View {
    var body: some View {
        Plan.RootScene.Display(viewModel: .init())
    }
}
