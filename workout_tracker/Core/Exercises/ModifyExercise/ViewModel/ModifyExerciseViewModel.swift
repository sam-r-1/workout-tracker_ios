//
//  ModifyExerciseViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation

extension ModifyExerciseView {
    
    @MainActor
    class ViewModel: ObservableObject {
        private var exercise: Exercise?
        @Published var modifyingState = ModifyingState.editing
        @Published var name: String
        @Published var type: String
        @Published var details: String
        @Published var includeWeight: Bool
        @Published var includeReps: Bool
        @Published var includeTime: Bool
        @Published var isEditingComplete = false
        
        let service = ExerciseService()
        let instanceService = ExerciseInstanceService()
        let templateService = TemplateService()
        
        init(exercise: Exercise? = nil) {
            self.exercise = exercise
            
            if let exercise {
                self.name = exercise.name
                self.type = exercise.type
                self.details = exercise.details
                self.includeWeight = exercise.includeWeight
                self.includeReps = exercise.includeReps
                self.includeTime = exercise.includeTime
            } else {
                self.name = ""
                self.type = ""
                self.details = ""
                includeWeight = false
                includeReps = false
                includeTime = false
            }
        }
        
        func modifyExercise() async {
            self.modifyingState = .loading

            do {
                try await service.setExercise(id: self.exercise?.id, name: self.name, type: self.type, details: self.details, includeWeight: self.includeWeight, includeReps: self.includeReps, includeTime: self.includeTime)

                self.isEditingComplete = true
            } catch {
                // Handle Error
                self.modifyingState = .error
            }
        }
        
        // delete an exercise and its associated instances
        func deleteExercise() async {
            self.modifyingState = .loading
            
            let id = self.exercise?.id! ?? ""
            let name = self.exercise?.name ?? ""
            
            do {
                try await service.deleteExercise(id: id)
                
                // delete associated instances
                self.instanceService.deleteInstances(ofExercise: id)
                
                // delete this exercise from templates
                try await self.templateService.deleteExerciseRef(id: id, name: name)
                
                self.isEditingComplete = true
                
            } catch {
                self.modifyingState = .error
            }
        }
    }
    
}
