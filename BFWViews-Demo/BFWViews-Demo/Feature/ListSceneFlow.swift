//
//  ListSceneFlow.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 21/5/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ListSceneFlow {
    let coordinator = Coordinator()
}

extension ListSceneFlow: View {
    var body: some View {
        coordinator.firstList
    }
}

struct ListSceneFlow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListSceneFlow()
        }
    }
}
