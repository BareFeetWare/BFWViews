//
//  RoundedBorderScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 5/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct RoundedBorderScene: View {
    var body: some View {
        List {
            Section {
                Text("Alone")
            }
            .roundedBorder(color: .orange, lineWidth: 4)
            Section {
                Text("Top")
                Text("Middle")
                Text("Bottom")
            }
            .roundedBorder(color: .secondary)
        }
    }
}

struct RoundedBorderScene_Previews: PreviewProvider {
    static var previews: some View {
        RoundedBorderScene()
    }
}
