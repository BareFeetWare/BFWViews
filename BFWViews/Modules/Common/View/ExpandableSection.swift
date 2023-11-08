//
//  ExpandableSection.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 11/9/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct ExpandableSection<Header: View, Content: View> {
    
    let isExpanded: Binding<Bool>?
    @ViewBuilder let content: () -> Content?
    let header: (() -> Header)?
    
    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        header: @escaping () -> Header
    ) {
        self.isExpanded = isExpanded
        self.content = content
        self.header = header
    }
    
    public init(
        @ViewBuilder content: @escaping () -> Content,
        header: (() -> Header)?
    ) {
        self.isExpanded = nil
        self.content = content
        self.header = header
    }
    
}

extension ExpandableSection where Header == Text {
    
    public init(
        _ title: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isExpanded = isExpanded
        self.content = content
        self.header = { Text(title) }
        
    }
    
    public init(
        _ title: String?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isExpanded = nil
        self.content = content
        self.header = title.map { title in
            { Text(title) }
        }
    }
    
}

extension ExpandableSection: View {
    public var body: some View {
        if let isExpanded {
            Section {
                DisclosureGroup(isExpanded: isExpanded) {
                    content()
                } label: {
                    headerView
                }
            }
        } else {
            nonExpandableSection
        }
    }
}

private extension ExpandableSection {
    
    var nonExpandableSection: some View {
        Section {
            content()
        } header: {
            header?()
        }
    }
    
    @ViewBuilder
    var headerView: some View {
        header?()
    }
    
}

struct ExpandableSection_Preview: PreviewProvider {
    
    struct Preview: View {
        @State var isExpandedSection1 = true
        @State var isExpandedSection2 = false
        
        var body: some View {
            List {
                ExpandableSection(
                    "Title",
                    isExpanded: $isExpandedSection1
                ) {
                    Text("Row 1")
                    Text("Row 2")
                }
                ExpandableSection(isExpanded: $isExpandedSection2) {
                    Text("Row 1")
                    Text("Row 2")
                } header: {
                    Text("Header")
                }
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
