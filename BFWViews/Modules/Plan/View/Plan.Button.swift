//
//  Plan.Button.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI

extension Plan {
    public struct Button {
        public let title: String
        public let systemImage: String?
        public let role: ButtonRole?
        public let action: () -> Void
        
        public init(
            _ title: String,
            systemImage: String? = nil,
            role: ButtonRole? = nil,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.systemImage = systemImage
            self.role = role
            self.action = action
        }
    }
}

// MARK: - Views

extension Plan.Button: View {
    public var body: some View {
        if let systemImage {
            Button(title, systemImage: systemImage, role: role, action: action)
        } else {
            Button(title, role: role, action: action)
        }
    }
}

// MARK: - Previews

struct Plan_Button_Previews: PreviewProvider {
    static var previews: some View {
        Plan.Button("Button") {}
    }
}
