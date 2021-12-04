//
//  UIKitViewController.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 23/11/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func uiViewController(_ customize: @escaping (UIViewController?) -> Void) -> some View {
        background(UIKitViewController(customize: customize))
    }
}

private struct UIKitViewController: UIViewControllerRepresentable {
    
    let customize: (UIViewController?) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        DispatchQueue.main.async {
            customize(uiViewController.parent)
        }
    }
    
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                NavigationLink("Child") { Text("Destination") }
            }
            .navigationTitle("View Controller")
            .uiViewController { $0?.navigationItem.backButtonTitle = "Customized Back" }
        }
    }
}
