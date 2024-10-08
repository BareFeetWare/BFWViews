//
//  NavigationHeader.swift
//
//  Created by Tom Brodhurst-Hill on 21/6/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    
    func navigationHeader(
        _ navigationHeader: NavigationHeader
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .principal) {
                navigationHeader
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func navigationHeader(
        title: String?,
        subtitle: String?
    ) -> some View {
        navigationHeader(
            .init(title: title, subtitle: subtitle)
        )
    }

}

public struct NavigationHeader {
    let title: String?
    let subtitle: String?
    
    public init(title: String?, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
}

extension NavigationHeader: View {
    public var body: some View {
        VStack {
            title.map {
                Text($0)
                    .bold()
            }
            subtitle.map {
                Text($0)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct NavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Content")
                .navigationHeader(
                    title: "Title",
                    subtitle: "Subtitle"
                )
        }
    }
}
