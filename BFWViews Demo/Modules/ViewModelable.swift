//
//  VioewModelable.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 20/4/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

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
    struct ViewModel: AnyViewModel {
        let id = UUID().uuidString
        // Add other properties specific to FirstView.ViewModel
        
        func createView() -> some View {
            FirstView(viewModel: self)
        }
    }
}

extension SecondView {
    struct ViewModel: AnyViewModel {
        let id = UUID().uuidString
        // Add other properties specific to SecondView.ViewModel
        
        func createView() -> some View {
            SecondView(viewModel: self)
        }
    }
}

struct ViewModelableView: View {
    let viewFactories: [AnyViewFactory] = [
        AnyViewFactory(FirstView.ViewModel()),
        AnyViewFactory(SecondView.ViewModel()),
        AnyViewFactory(FirstView.ViewModel())
    ]

    var body: some View {
        List {
            ForEach(viewFactories) { viewFactory in
                viewFactory.createView()
            }
        }
    }
}

struct ViewModelableView_Previews: PreviewProvider {
    static var previews: some View {
        ViewModelableView()
    }
}
