//
//  RepsFormatter.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/26/22.
//

import Foundation

class RepsFormatter {
    static var reps: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.zeroSymbol = ""
        return numberFormatter
    }()
}
