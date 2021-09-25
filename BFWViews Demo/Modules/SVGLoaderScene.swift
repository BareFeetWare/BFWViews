//
//  SVGLoaderScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct SVGLoaderScene {
    let url = Bundle.main.url(forResource: "city", withExtension: "svg")!
}

extension SVGLoaderScene: View {
    var body: some View {
        SVGImage(url: url, loadingView: ProgressView())
    }
}

struct SVGImageScene_Preview: PreviewProvider {
    static var previews: some View {
        SVGLoaderScene()
    }
}
