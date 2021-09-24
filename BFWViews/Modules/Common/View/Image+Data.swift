//
//  Image+Data.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 24/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI

extension Image {
    init?(data: Data) {
        guard let uiImage = UIImage(data: data)
        else { return nil }
        self = Image(uiImage: uiImage)
    }
}
