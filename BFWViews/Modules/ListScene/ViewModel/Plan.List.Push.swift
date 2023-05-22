//
//  Plan.List.Push.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 22/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Plan.List {
    /// Object to pass between a List and the child views that need to manipulate it, such as AsyncNavigationLink.
    public class Push: ObservableObject {
        public init(
            isActiveDestination: Bool = false,
            destination: (any View)? = nil
        ) {
            self.isActiveDestination = isActiveDestination
            self.destination = destination
        }
        
        @Published public var isActiveDestination: Bool
        
        @Published public var destination: (any View)? {
            didSet {
                // TODO: Perhaps instead use subscriber.
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.isActiveDestination = self.destination != nil
                }
            }
        }
    }
}
