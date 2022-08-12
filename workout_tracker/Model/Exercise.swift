//
//  Exercise.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import Foundation

struct Exercise: Identifiable, Decodable {
    let name: String
    let type: String
    let includeReps: Bool
    let includeTime: Bool
}
