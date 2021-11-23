//
//  ViewControllerScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 23/11/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ViewControllerScene {}

extension ViewControllerScene: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Child") { Text("Destination") }
            }
            .navigationTitle("View Controller")
            .viewController { $0?.navigationItem.backButtonTitle = "Customized Back" }
        }
    }
}

struct ViewControllerScene_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerScene()
    }
}
