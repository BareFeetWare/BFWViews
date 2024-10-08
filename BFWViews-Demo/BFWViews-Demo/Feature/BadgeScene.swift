//
//  BadgeScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 12/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct BadgeScene: View {
    var body: some View {
        List {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarItems(trailing: trailingButtons)
        .navigationTitle("Badge")
    }
}

private extension BadgeScene {
    var trailingButtons: some View {
        HStack {
            Button {
                // action
            } label: {
                Image(symbol: .heart)
            }
            .badge(
                foreground: Text("124")
                    .colorScheme(.dark),
                background: Color.red
            )
            Button {
                // action
            } label: {
                Image(symbol: .person)
            }
            .badge(background: Color.green)
        }
    }
}

struct BadgeScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BadgeScene()
        }
    }
}
