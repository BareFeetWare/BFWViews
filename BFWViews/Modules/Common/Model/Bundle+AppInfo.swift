//
//  Binding+AppInfo.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 1/6/2025.
//  Copyright © 2024 BareFeetWare. All rights reserved.
//

// Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import Foundation

public extension Bundle {
    
    var shortVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
    
    var longVersion: String? {
        "Version \(shortVersion ?? "?") (Build \(buildVersion ?? "?"))"
    }
    
    var appName: String? {
        infoDictionary?["CFBundleDisplayName"] as? String
        ??
        infoDictionary?["CFBundleName"] as? String
    }
    
}
