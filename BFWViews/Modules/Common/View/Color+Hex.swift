//
//  Color+Hex.swift
//
//  Created by Tom Brodhurst-Hill on 8/9/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension Color {
    init?(hexString: String, opacity: CGFloat = 1.0) {
        guard let uiColor = UIColor(hexString: hexString, alpha: opacity)
        else { return nil }
        self.init(uiColor)
    }
}

public extension UIColor {
    
    convenience init(hexValue: UInt32, alpha: CGFloat) {
        self.init(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0xFF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init?(hexString: String, alpha: CGFloat) {
        let cleanHexString = hexString.replacingOccurrences(of: "#", with: "0x")
        var hexValue: UInt32 = 0
        if Scanner(string: cleanHexString).scanHexInt32(&hexValue) {
            self.init(hexValue: hexValue, alpha: alpha)
        } else {
            return nil
        }
    }
    
}

struct Color_Hex_Previews: PreviewProvider {
    
    static let hexStrings = [
        "#FF0000",
        "#00FF00",
        "#0000FF",
    ]
    
    static var previews: some View {
        NavigationView {
            List(hexStrings, id: \.self) { hexString in
                HStack {
                    Text(hexString)
                    Spacer()
                    Color(hexString: hexString)
                }
            }
            .navigationTitle("Color+Hex")
        }
    }
    
}
