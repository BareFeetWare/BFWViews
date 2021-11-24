//
//  ViewController.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 23/11/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func viewController(_ customize: @escaping (UIViewController?) -> Void) -> some View {
        background(ViewController(customize: customize))
    }
}

private struct ViewController: UIViewControllerRepresentable {
    
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
            .viewController { $0?.navigationItem.backButtonTitle = "Customized Back" }
        }
    }
}
