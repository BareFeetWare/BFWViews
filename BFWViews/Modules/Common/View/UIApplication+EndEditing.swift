//
//  UIApplication+EndEditing.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 6/5/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension UIApplication {
    /// Sends `resignFirstResponder` up the responder chain, dismissing any keyboard currently shown.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
