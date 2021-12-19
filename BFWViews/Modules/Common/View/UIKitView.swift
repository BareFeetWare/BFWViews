//
//  UIKitView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/12/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    
    func uiView(customize: @escaping (UIView) -> Void) -> some View {
        background(UIKitView(customize: customize))
    }
    
    func uiView<T: UIView>(ofType type: T.Type, customize: @escaping (T) -> Void) -> some View {
        background(
            UIKitView { view in
                guard let matchingView = (view as? T) ?? view.ancestorView(ofType: type)
                else { return }
                customize(matchingView)
            }
        )
    }
    
    func uiTableViewCell(customize: @escaping (UITableViewCell) -> Void) -> some View {
        uiView(ofType: UITableViewCell.self) { cell in
            customize(cell)
        }
    }
    
}

private extension UIView {
    func ancestorView<T>(ofType type: T.Type) -> T? {
        return (superview as? T) ?? superview?.ancestorView(ofType: type)
    }
}

private struct UIKitView: UIViewRepresentable {
    
    let customize: (UIView) -> Void
    
    func makeUIView(context: Context) -> some UIView {
        let embeddedView = EmbeddedView(frame: .zero, customize: customize)
        embeddedView.backgroundColor = .clear
        return embeddedView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Ignored
    }
    
}

private class EmbeddedView: UIView {
    
    init(frame: CGRect, customize: @escaping (UIView) -> Void) {
        self.customize = customize
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let customize: (UIView) -> Void
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let superview = superview else { return }
        customize(superview)
    }
    
}

struct UIKitView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Alone")
            }
            Section {
                Text("Top")
                    .uiTableViewCell { $0.accessoryType = .checkmark }
                Text("Middle")
                Text("Bottom")
            }
        }
    }
}
