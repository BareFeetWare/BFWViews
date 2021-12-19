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
        background(
            UIKitViewController(customize: customize)
        )
    }
    
    func uiNavigationController(_ customize: @escaping (UINavigationController?) -> Void) -> some View {
        background(
            UIKitViewController(customize: { customize($0?.navigationController) })
        )
    }
    
}

private struct UIKitViewController: UIViewControllerRepresentable {
    
    let customize: (UIViewController?) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        EmbeddedViewController(customize: customize)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // TODO: Perhaps avoid calling this on instantiation, if already called in make.
        customize(uiViewController.parent)
    }
    
}

private class EmbeddedViewController: UIViewController {
    
    init(customize: @escaping (UIViewController?) -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.view = EmbeddedView(frame: .zero) { [weak self] _ in
            guard let parent = self?.parent
            else { return }
            customize(parent)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
