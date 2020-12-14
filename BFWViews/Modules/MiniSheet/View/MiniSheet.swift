//
//  MiniSheet.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 14/12/20.
//

import SwiftUI

class MiniSheet: ObservableObject {
    
    var content: AnyView? {
        didSet {
            updateOverlay(content: content)
        }
    }
    
    @Published var overlay: AnyView?
    
    private func updateOverlay(content: AnyView?) {
        overlay = content.map { content in
            AnyView(
                Rectangle()
                    .foregroundColor(Color.purple.opacity(0.2))
                    .ignoresSafeArea()
                    .overlay(
                        content
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 10)
                    )
            )
        }
    }
}

struct MiniSheet_Previews: PreviewProvider {
    static var previews: some View {
        return
            NavigationView {
                Text("Main")
                    .overlay(AnyView(MiniSheet().overlay))
            }
    }
}
