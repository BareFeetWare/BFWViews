//
//  ExpandableSection.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 11/9/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct ExpandableSection<Header: View, Footer: View, Content: View> {
    let isExpanded: Binding<Bool>?
    @ViewBuilder let content: () -> Content?
    let header: (() -> Header)?
    let footer: (() -> Footer)?
}

// MARK: - Convenience Inits

public extension ExpandableSection {
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        header: (() -> Header)?,
        footer: (() -> Footer)? = nil
    ) {
        self.isExpanded = nil
        self.content = content
        self.header = header
        self.footer = footer
    }
    
}

public extension ExpandableSection where Footer == Text {
    
    init(
        isExpanded: Binding<Bool>? = nil,
        @ViewBuilder content: @escaping () -> Content,
        header: (() -> Header)?
    ) {
        self.init(
            isExpanded: isExpanded,
            content: content,
            header: header,
            footer: nil
        )
    }
        
}

extension ExpandableSection where Header == Text, Footer == Text {
    
    public init(
        _ title: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isExpanded = isExpanded
        self.content = content
        self.header = { Text(title) }
        self.footer = nil
    }
    
    public init(
        _ title: String?,
        footer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            content: content,
            header: title.map { title in
                { Text(title) }
            },
            footer: footer.map { footer in
                { Text(footer) }
            }
        )
    }
    
}

// MARK: - Views

extension ExpandableSection: View {
    public var body: some View {
        if let isExpanded {
            Section {
                DisclosureGroup(isExpanded: isExpanded) {
                    content()
                } label: {
                    header?()
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
        } footer: {
            footer?()
        }
    }
    
}

// MARK: - Previews

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
