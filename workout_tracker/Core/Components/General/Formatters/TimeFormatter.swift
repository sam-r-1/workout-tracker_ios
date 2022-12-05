//
//  TimeFormatter.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/5/22.
//

import Foundation

class TimeFormatter {
    static var durationResult: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.zeroFormattingBehavior = .dropLeading
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.allowsFractionalUnits = true
        timeFormatter.unitsStyle = .abbreviated
        return timeFormatter
    }()
    
    static var timerFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        formatter.allowsFractionalUnits = true
        return formatter
    }()
}
