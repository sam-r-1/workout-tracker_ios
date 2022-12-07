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
    var exercise: Exercise? = nil {
        didSet { self.parent.update() }
    }
    let instance: ExerciseInstance
    private let parent: WorkoutDetailsViewModel
    private let exerciseService = ExerciseService()
    private let instanceService = ExerciseInstanceService()
    
    init(fromInstance instance: ExerciseInstance, parent: WorkoutDetailsViewModel) {
        self.instance = instance
        self.parent = parent
        fetchExerciseById(instance.exerciseId)
    }
    
    private func fetchExerciseById(_ id: String) {
        exerciseService.fetchExerciseById(id: id) { exercise in
            self.exercise = exercise
        }
    }
}
