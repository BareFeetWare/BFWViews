//
//  ReadFrameScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 22/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct ReadFrameScene {
    @State private var descriptionFrame: CGRect = .zero
}

private extension ReadFrameScene {
    var spaceName: String { String(describing: self) }
    var space: CoordinateSpace { .named(spaceName) }
    var arrowOffsetY: CGFloat { descriptionFrame.minY }
}

extension ReadFrameScene: View {
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .trailing) {
                    Rectangle()
                        .foregroundColor(.yellow)
                        .frame(height: arrowOffsetY)
                        .overlay(
                            Text("This offset Rectangle would normally just be a Spacer, so it's not visible.")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .padding()
                        )
                    Image(symbol: .arrowRight)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Image(symbol: .photo)
                        .imageScale(.large)
                    Text("Subtitle with lots of text that often wraps over multiple lines, making the height change")
                        .foregroundColor(.secondary)
                    Text("Description to align")
                        .readFrame(in: space, writer: { descriptionFrame = $0 })
                }
                .padding()
                .card()
            }
            .coordinateSpace(name: spaceName)
            .padding()
        }
        .navigationTitle("ReadFrame")
    }
}

struct ReadFrame_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReadFrameScene()
        }
    }
}
