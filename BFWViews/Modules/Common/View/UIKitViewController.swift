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
        EmbeddedViewController(customize: customize)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Ignore
    }
    
}

private class EmbeddedViewController: UIViewController {
    
    init(customize: @escaping (UIViewController?) -> Void) {
        self.customize = customize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let customize: (UIViewController?) -> Void
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if let parent = parent {
            customize(parent)
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
