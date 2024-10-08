//
//  AlertScene.swift
//  BFWViews Demo
//
//  Created by Tom Brodhurst-Hill on 4/6/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI
import BFWViews

struct AlertScene {
    
    @State private var error: Error? {
        didSet {
            isPresentedAlert = true
        }
    }
    
    @State private var isPresentedAlert = false
    
    enum Error: Swift.Error {
        case test
    }
}

extension AlertScene: View {
    var body: some View {
        Form {
            Button("Error Alert") { error = .test }
        }
        .alert(isPresented: $isPresentedAlert) {
            Alert(error: error)
        }
    }
}

struct AlertScene_Previews: PreviewProvider {
    static var previews: some View {
        AlertScene()
    }
}
