//
//  TemplateExercise.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/1/22.
//

import Foundation

struct TemplateExercise: Identifiable {
    let uuid = UUID()
    let exercise: Exercise
    let templatePos: Int // Position of the exercise within the template
}
