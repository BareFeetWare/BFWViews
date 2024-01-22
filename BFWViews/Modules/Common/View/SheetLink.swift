//
//  SheetLink.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 22/1/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

import SwiftUI

struct SheetLink<Label: View, Destination: View> {
    let isPresentedExternal: Binding<Bool>?
    let destination: () -> Destination
    let label: () -> Label
    
    @State private var isPresentedInternal = false
}

extension SheetLink {
    
    init(isPresented: Binding<Bool>? = nil, destination: @escaping () -> Destination, label: @escaping () -> Label) {
        self.isPresentedExternal = isPresented
        self.destination = destination
        self.label = label
    }
    
    var isPresentedBinding: Binding<Bool> {
        isPresentedExternal ?? $isPresentedInternal
    }
}

extension SheetLink where Label == Text {
    
    init(_ title: String, isPresented: Binding<Bool>? = nil, destination: @escaping () -> Destination) {
        self.init(
            isPresented: isPresented,
            destination: destination,
            label: { Text(title) }
        )
    }
}

extension SheetLink: View {
    var body: some View {
        Button {
            isPresentedBinding.wrappedValue = true
        } label: {
            label()
        }
        .sheet(isPresented: isPresentedBinding) {
            destination()
        }
    }
}

struct SheetLink_Previews: PreviewProvider {
    
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        
        @State var isPresented = false
        
        var body: some View {
            SheetLink(isPresented: $isPresented) {
                Text("Destination")
            } label: {
                Text("SheetLink Label")
            }
        }
    }
}
