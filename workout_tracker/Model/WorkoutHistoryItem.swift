//
//  WorkoutHistoryItem.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/6/22.
//

import Foundation

class WorkoutHistoryItem: Identifiable, Equatable {
    static func == (lhs: WorkoutHistoryItem, rhs: WorkoutHistoryItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let exercise: Exercise
    let instance: ExerciseInstance
    
    init(exercise: Exercise, instance: ExerciseInstance) {
        self.exercise = exercise
        self.instance = instance
    }
}
