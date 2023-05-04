//
//  View+Boss.ListStyle.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

extension View {
    func listStyle(_ listStyle: Boss.ListStyle) -> some View {
        modifier(ListStyleModifier(listStyle: listStyle))
    }
}

fileprivate struct ListStyleModifier: ViewModifier {
    let listStyle: Boss.ListStyle

    @ViewBuilder
    func body(content: Content) -> some View {
        switch listStyle {
        case .automatic:
            content.listStyle(DefaultListStyle())
        case .insetGrouped:
            content.listStyle(InsetGroupedListStyle())
        case .inset:
            content.listStyle(InsetListStyle())
        case .grouped:
            content.listStyle(GroupedListStyle())
        case .plain:
            content.listStyle(PlainListStyle())
        case .sidebar:
            content.listStyle(SidebarListStyle())
        }
    }
}
