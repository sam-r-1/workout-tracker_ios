//
//  ModifyExerciseViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation

class ModifyExerciseViewModel: ObservableObject {
    private var exercise: Exercise?
    @Published var name: String
    @Published var type: String
    @Published var details: String
    @Published var includeWeight: Bool
    @Published var includeReps: Bool
    @Published var includeTime: Bool
    @Published var didCreateExercise = false
    
    let service = ExerciseService()
    let instanceService = ExerciseInstanceService()
    
    init(exercise: Exercise? = nil) {
        self.exercise = exercise
        
        if exercise == nil {
            self.name = ""
            self.type = ""
            self.details = ""
            includeWeight = false
            includeReps = false
            includeTime = false
        } else {
            self.name = exercise!.name
            self.type = exercise!.type
            self.details = exercise!.details
            self.includeWeight = exercise!.includeWeight
            self.includeReps = exercise!.includeReps
            self.includeTime = exercise!.includeTime
        }
    }
    
    func modifyExercise() {
        service.setExercise(id: self.exercise?.id, name: self.name, type: self.type, details: self.details, includeWeight: self.includeWeight, includeReps: self.includeReps, includeTime: self.includeTime) { success in
            if success {
                // dismiss screen
                self.didCreateExercise = true
            } else {
                // show error message to user
            }
        }
    }
    
    // delete an exercise and its associated instances
    func deleteExercise() {
        let id = self.exercise?.id! ?? ""
        
        service.deleteExercise(id: id) { success in
            if success {
                // delete associated instances
                self.instanceService.deleteInstances(ofExercise: id)
            }
        }
    }
}
