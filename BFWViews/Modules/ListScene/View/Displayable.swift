//
//  Displayable.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

public protocol Displayable {
    associatedtype Displayed: View
    func view() -> Displayed
}
