//
//  MiniSheetScene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//

import SwiftUI

struct MiniSheetScene: View {
    
    @EnvironmentObject var miniSheet: MiniSheet
    
    var body: some View {
        List {
            Button("Info") {
                miniSheet.content = AnyView(infoView)
            }
            Button("Amazing") {
                miniSheet.content = AnyView(amazingView)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var infoView: some View {
        VStack {
            Text("Info")
            Button("OK") { miniSheet.content = nil }
        }
    }
    
    var amazingView: some View {
        VStack {
            Text("Amazing!")
            Button("OK") { miniSheet.content = nil }
        }
    }
    
}

struct MiniSheetScene_Previews: PreviewProvider {
    static var previews: some View {
        MiniSheetScene()
    }
}
