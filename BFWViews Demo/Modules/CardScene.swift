//
//  CardScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 3/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

struct CardScene {}

extension CardScene: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing) {
                Section(
                    header: Text("Section 1 Header")
                        .font(.subheadline)
                        .bold()
                        .distributed(.leading)
                ) {
                    VStack {
                        Text("Detail line 1")
                        Text("Detail line 2")
                    }
                    .distributed(.leading)
                }
                .padding(.horizontal)
                .card()
                Section(
                    header: Text("Section 2 Header")
                        .font(.subheadline)
                        .bold()
                        .distributed(.leading)
                ) {
                    VStack {
                        Text("Detail line 1")
                        Text("Detail line 2")
                    }
                    .distributed(.leading)
                }
                .padding(.horizontal)
                .card()
            }
            .multilineTextAlignment(.leading)
        }
        .navigationTitle("Card")
    }
}

struct CardScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CardScene()
        }
    }
}
