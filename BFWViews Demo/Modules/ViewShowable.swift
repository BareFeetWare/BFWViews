//
//  ViewShowable.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 20/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

extension FirstView.ViewModel: ViewShowable {
    func view() -> AnyView {
        AnyView(FirstView(viewModel: self))
    }
}

extension SecondView.ViewModel: ViewShowable {
    func view() -> AnyView {
        AnyView(SecondView(viewModel: self))
    }
}

struct FirstView: View {
    let viewModel: ViewModel

    var body: some View {
        Text("View1")
        // Implement the view content here, using the view model.
    }
}

struct SecondView: View {
    let viewModel: ViewModel

    var body: some View {
        Text("View2")
        // Implement the view content here, using the view model.
    }
}

extension FirstView {
    struct ViewModel: Identifiable {
        let id = UUID().uuidString
        // Add other properties specific to FirstView.ViewModel

        func view() -> some View {
            FirstView(viewModel: self)
        }
    }
}

extension SecondView {
    struct ViewModel: Identifiable {
        let id = UUID().uuidString
        // Add other properties specific to SecondView.ViewModel

        func view() -> some View {
            SecondView(viewModel: self)
        }
    }
}

struct ViewShowableScene: View {
    
    let viewModel = ViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.cellViewModels) { cellViewModel in
                cellViewModel.view()
            }
        }
    }
    
    func testView() -> some View {
        Text("test")
    }
}

extension ViewShowableScene {
    struct ViewModel {
        let cellViewModels: [Boss.Cell] = [
            .init(FirstView.ViewModel()),
            .init(SecondView.ViewModel()),
        ]
    }
}
