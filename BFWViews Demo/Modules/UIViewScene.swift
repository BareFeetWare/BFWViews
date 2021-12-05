//
//  UIViewScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 4/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct UIViewScene: View {
    var body: some View {
        List {
            Section {
                Text("Alone")
            }
            Section {
                Text("Top")
                    .uiTableViewCell { cell in
                        cell.accessoryType = .detailDisclosureButton
                    }
                Text("Middle")
                Text("Bottom")
            }
        }
    }
}

struct UIViewScene_Previews: PreviewProvider {
    static var previews: some View {
        UIViewScene()
    }
}
