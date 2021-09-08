//
//  ColorHexScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 8/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct ColorHexScene {
    let hexStrings = [
        "#FF0000",
        "#00FF00",
        "#0000FF",
    ]
}

extension ColorHexScene: View {
    var body: some View {
        List(hexStrings, id: \.self) { hexString in
            HStack {
                Text(hexString)
                Spacer()
                Color(hexString: hexString)
            }
        }
        .navigationTitle("Color+Hex")
    }
}

struct ColorHexScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColorHexScene()
        }
    }
}
