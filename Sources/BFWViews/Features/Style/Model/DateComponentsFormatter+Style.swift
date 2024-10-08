//
//  DateComponentsFormatter+Style.swift
//
//  Created by Tom Brodhurst-Hill on 24/3/20.
//  Copyright © 2020 BareFeetWare. All rights reserved.
//

import Foundation

public extension DateComponentsFormatter {
    
    static let hourMinute: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter
    }()
    
    static let hourMinuteShort: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        return formatter
    }()
    
    static let timeRemaining: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.includesTimeRemainingPhrase = true
        return formatter
    }()
    
    static let yearMonthDay2: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        return formatter
    }()
    
}
