//
//  WeightFormatter.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/5/22.
//

import Foundation

class WeightFormatter {
    static var weight: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.maximumFractionDigits = 1
        return numFormatter
    }()
}
