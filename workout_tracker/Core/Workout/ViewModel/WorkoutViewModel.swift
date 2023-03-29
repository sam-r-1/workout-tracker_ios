//
//  WorkoutViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import Foundation
import Firebase

extension WorkoutView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var workoutState = WorkoutState.active
        @Published var items = [ExerciseDataFields]()
        
        private let exerciseService = ExerciseService()
        private let workoutService = WorkoutService()
        private let instanceService = ExerciseInstanceService()
        
        nonisolated func update() {
            self.objectWillChange.send()
        }
        
        func addItem(_ exerciseId: String) {
            fetchAndSetExerciseById(exerciseId) { exercise in
                self.items.append(ExerciseDataFields(parent: self, exercise: exercise))
            }
        }
        
        func deleteItem(at index: Int) {
            items.remove(at: index)
        }
        
        func moveItem(from source: IndexSet, to destination: Int) {
            self.items.move(fromOffsets: source, toOffset: destination)
        }
        
        func addExercisesFromTemplate(_ template: Template) async {
            do {
                let exercises = try await exerciseService.fetchExercises(fromIdList: template.exerciseIdList)
                
                for exercise in exercises {
                    self.items.append(ExerciseDataFields(parent: self, exercise: exercise))
                }
            } catch _ {}
        }
        
        private func fetchAndSetExerciseById(_ id: String, completion: @escaping (Exercise) -> Void) {
            exerciseService.fetchExerciseById(id: id) { exercise in
                completion(exercise)
            }
        }
        
        func finishWorkout() async {
            self.workoutState = .submitting
            
            do {
                let instanceIdList = try await instanceService.uploadInstances(self.items.instanceList())
                
                try await workoutService.uploadWorkout(exerciseInstanceIdList: instanceIdList)
                
                self.workoutState = .finished
                
            } catch {
                self.workoutState = .error
            }
        }
    }
    
    enum WorkoutState {
        case active, submitting, finished, error
    }
}
