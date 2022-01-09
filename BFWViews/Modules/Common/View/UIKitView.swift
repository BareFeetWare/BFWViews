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
        overlay(
            UIKitView(customize: customize)
                .frame(width: 0, height: 0, alignment: .topLeading)
        )
    }
    
    func uiView<T: UIView>(ofType type: T.Type, customize: @escaping (T) -> Void) -> some View {
        uiView { view in
            guard let matchingView = (view as? T) ?? view.ancestorView(ofType: type)
            else { return }
            customize(matchingView)
        }
    }
    
    func uiViewHostedSibling<T: UIView>(ofType type: T.Type, customize: @escaping (T) -> Void) -> some View {
        uiView { view in
            view.hostedSiblingView(ofType: type)
                .map { customize($0) }
        }
    }
    
    /// Apply to List or Form to customize the underlying UITableView.
    func uiTableView(customize: @escaping (UITableView) -> Void) -> some View {
        uiViewHostedSibling(ofType: UITableView.self, customize: customize)
    }
    
    /// Apply to a subview in a List or Form to customize the underlying UITableViewCell.
    func uiTableViewCell(customize: @escaping (UITableViewCell) -> Void) -> some View {
        uiView(ofType: UITableViewCell.self) { cell in
            customize(cell)
        }
    }
    
    func tableViewProxy(
        _ tableViewProxy: TableViewProxy,
        heightForHeaderInSection: ((Int) -> CGFloat?)? = nil,
        heightForFooterInSection: ((Int) -> CGFloat?)? = nil
    ) -> some View {
        uiTableView { tableView in
            if tableView.delegate as? TableViewProxy != tableViewProxy {
                tableViewProxy.delegate = tableView.delegate
                tableView.delegate = tableViewProxy
                tableViewProxy.heightForHeaderInSection = heightForHeaderInSection
                tableViewProxy.heightForFooterInSection = heightForFooterInSection
                tableView.reloadData() // Needed?
            }
        }
    }

}

private extension UIView {
    
    func ancestorView<T>(ofType type: T.Type) -> T? {
        (superview as? T) ?? superview?.ancestorView(ofType: type)
    }
    
    func subview<T>(ofType: T.Type) -> T? {
        subviews.first { $0 is T } as? T
    }
    
    func hostedSiblingView<T>(ofType: T.Type) -> T? {
        superview?.subviews
            .filter { $0 != self && NSStringFromClass(type(of: $0)).contains("ViewHost") }
            .compactMap { $0.subview(ofType: T.self) }
            .first
    }
    
}

private struct UIKitView: UIViewRepresentable {
    
    let customize: (UIView) -> Void
    
    func makeUIView(context: Context) -> some UIView {
        EmbeddedView(frame: .zero, customize: customize)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        customize(uiView)
    }
    
}

internal class EmbeddedView: UIView {
    
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
