//
//  WebScene.swift
//  BFWViews Demo
//
//  Created by Danielle Hill on 8/7/2022.
//  Copyright © 2022 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct WebScene {}

extension WebScene: View {
    var body: some View {
        WebView(
            title: .constant("Title"),
            urlRequest: URLRequest(url: URL(string: "https://www.barefeetware.com")!)
        )
    }
}

struct WebScene_Previews: PreviewProvider {
    static var previews: some View {
        WebScene()
    }
}
