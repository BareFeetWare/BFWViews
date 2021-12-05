//
//  UIViewScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 4/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

// TODO: Add better use cases.

struct UIViewScene: View {
    var body: some View {
        List {
            Text("Cell")
                .uiTableViewCell { cell in
                    cell.accessoryType = .checkmark
                }
        }
    }
}

struct UIViewScene_Previews: PreviewProvider {
    static var previews: some View {
        UIViewScene()
    }
}
