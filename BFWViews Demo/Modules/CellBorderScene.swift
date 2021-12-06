//
//  CellBorderScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 5/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct CellBorderScene: View {
    var body: some View {
        List {
            Section {
                Text("Alone")
            }
            .cellBorder(color: .orange, lineWidth: 4)
            Section {
                Text("Top")
                Text("Middle")
                Text("Bottom")
            }
            .cellBorder(color: .secondary)
        }
    }
}

struct CellBorderScene_Previews: PreviewProvider {
    static var previews: some View {
        CellBorderScene()
    }
}
