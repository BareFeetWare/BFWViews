//
//  MiniSheetScene.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//

import SwiftUI

struct MiniSheetScene: View {
    
    @EnvironmentObject var miniSheetManager: MiniSheet.Manager
    
    var body: some View {
        NavigationView {
            List {
                Button("Info") {
                    miniSheetManager.content = AnyView(infoView)
                }
                Button("Amazing") {
                    miniSheetManager.content = AnyView(amazingView)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    var infoView: some View {
        VStack {
            Text("Info")
            Button("OK") { miniSheetManager.content = nil }
        }
    }
    
    var amazingView: some View {
        VStack {
            Text("Amazing!")
            Button("OK") { miniSheetManager.content = nil }
        }
    }

}

struct MiniSheetScene_Previews: PreviewProvider {
    static var previews: some View {
        MiniSheetScene()
    }
}
