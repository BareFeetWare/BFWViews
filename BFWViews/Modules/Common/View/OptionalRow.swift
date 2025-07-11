//
//  OptionalRow.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/9/2024.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

//  Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

public struct OptionalRow<Content: Identifiable & View> {
    let noneString: String
    let content: Content?
}

extension OptionalRow: Identifiable {
    public var id: String {
        guard let content
        else { return noneString }
        return String(describing: content.id)
    }
}

// MARK: - Views

extension OptionalRow: View {
    public var body: some View {
        if let content {
            content
        } else {
            IdentifiableText(noneString)
        }
    }
}

struct OptionalRow_Previews: PreviewProvider {

    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        let nonNilText: IdentifiableText? = .init("Text")
        let nilText: IdentifiableText? = nil
        
        var body: some View {
            List {
                OptionalRow(noneString: "None", content: nonNilText)
                OptionalRow(noneString: "None", content: nilText)
            }
        }
    }
}
