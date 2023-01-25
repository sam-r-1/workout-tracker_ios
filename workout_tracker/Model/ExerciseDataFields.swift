//
//  ExerciseDataFields.swift
//  workout_tracker
//
//  Created by Sam Rankin on 1/23/23.
//

import Foundation

class ExerciseDataFields: Identifiable {
    
    init(parent: WorkoutViewModel, exercise: Exercise) {
        self.parent = parent
        self.exercise = exercise
    }
    
    let id = UUID()
    private let parent: WorkoutViewModel
    let exercise: Exercise
    let instanceService = ExerciseInstanceService()
    
    var weight: Double = 0.0 {
        // didSet { self.parent.update() }
        didSet { self.checkForExerciseCompleted() }
    }
    
    var reps: Int = 0 {
        // didSet { self.parent.update() }
        didSet { self.checkForExerciseCompleted() }
    }
    
    var time: Double = 0.0 {
        // didSet { self.parent.update() }
        didSet { self.checkForExerciseCompleted() }
    }
    
    var exerciseCompleted = false {
        didSet { self.parent.update() }
    }
    
    var previousInstance: ExerciseInstance? = nil {
        didSet { self.parent.update() }
    }
    
    func fetchPreviousInstance() {
        instanceService.fetchMostRecentInstance(byExerciseId: self.exercise.id!) { instance in
            self.previousInstance = instance
        }
    }
    
    private func checkForExerciseCompleted() {
        if self.exercise.includeWeight {
            guard self.weight > 0.0 else { self.exerciseCompleted = false; return }
        }
        
        if self.exercise.includeReps {
            guard self.reps > 0 else { self.exerciseCompleted = false; return }
        }
        
        if self.exercise.includeTime {
            guard self.time > 0.5 else { self.exerciseCompleted = false; return }
        }
        
        self.exerciseCompleted = true
    }
}

extension ExerciseDataFields: Equatable {
    static func == (lhs: ExerciseDataFields, rhs: ExerciseDataFields) -> Bool {
        return lhs.id == rhs.id
    }
}

