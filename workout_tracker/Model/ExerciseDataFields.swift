//
//  ExerciseDataFields.swift
//  workout_tracker
//
//  Created by Sam Rankin on 1/23/23.
//

import Foundation
import Firebase

class ExerciseDataFields: Identifiable {
    
    init(parent: WorkoutView.ViewModel, exercise: Exercise) {
        self.parent = parent
        self.exercise = exercise
    }
    
    let id = UUID()
    private let parent: WorkoutView.ViewModel
    let exercise: Exercise
    let instanceService = ExerciseInstanceService()
    
    var weight: Double = 0.0 {
        didSet { self.checkForExerciseCompleted() }
    }
    
    var reps: Int = 0 {
        didSet { self.checkForExerciseCompleted() }
    }
    
    var time: Double = 0.0 {
        didSet { self.checkForExerciseCompleted() }
    }
    
    var exerciseCompleted = false {
        didSet { self.parent.update() }
    }
    
    var previousInstance: ExerciseInstance? = nil {
        didSet { self.parent.update() }
    }
    
    @MainActor
    func fetchPreviousInstance() async {
        do {
            self.previousInstance = try await instanceService.fetchMostRecentInstance(byExerciseId: self.exercise.id!)
        } catch _ {}
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

extension Array where Element == ExerciseDataFields {
    func instanceList() -> [ExerciseInstance] {
        var instanceList = [ExerciseInstance]()
        
        for item in self {
            instanceList.append(ExerciseInstance(uid: "-999", exerciseId: item.exercise.id!, timestamp: Timestamp(), reps: item.reps, time: item.time, weight: item.weight))
        }
        
        return instanceList
    }
}

