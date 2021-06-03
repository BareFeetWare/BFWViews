//
//  DistributedScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 3/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct DistributedScene {}

extension DistributedScene: View {
    var body: some View {
        List {
        Group {
            Text("top").distributed(.top)
            Text("center").distributed(VerticalAlignment.center)
            Text("bottom").distributed(.bottom)
            Text("leading").distributed(.leading)
            Text("center").distributed(HorizontalAlignment.center)
            Text("trailing").distributed(.trailing)
        }
        .frame(width: .infinity, height: 60)
        .background(Color.yellow)
        }
        .navigationTitle("Distributed")
    }
}

struct DistributedScene_Previews: PreviewProvider {
    static var previews: some View {
        DistributedScene()
    }
}
