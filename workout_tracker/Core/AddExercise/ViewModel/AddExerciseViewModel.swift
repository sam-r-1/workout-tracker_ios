//
//  AddExerciseViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation

class AddExerciseViewModel: ObservableObject {
    @Published var didCreateExercise = false
    
    let service = ExerciseService()
    
    func createExercise(name: String, type: String, details: String, includeWeight: Bool, includeReps: Bool, includeTime: Bool) {
        service.createExercise(name: name, type: type, details: details, includeWeight: includeWeight, includeReps: includeReps, includeTime: includeTime) { success in
            if success {
                // dismiss screen
                self.didCreateExercise = true
            } else {
                // show error message to user
            }
        }
    }
}
