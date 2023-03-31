//
//  HistoryViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 3/31/23.
//

import Foundation

extension HistoryView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        // UI properties
        @Published var loadingState = LoadingState.loading
        
        // MARK: History data
        // all history data
        @Published var exercises = [Exercise]()
        @Published var instances = [ExerciseInstance]()
        @Published var workouts = [Workout]()
        
        // specific history data
        @Published var historyItems = [WorkoutHistoryItem]()
        
        // Services
        private let exerciseService = ExerciseService()
        private let instanceService = ExerciseInstanceService()
        private let workoutService = WorkoutService()
        
        // MARK: - Functions
        
        func fetchUserHistory() async {
            do {
                self.exercises = try await exerciseService.fetchExercises()
                self.instances = try await instanceService.fetchInstances()
                self.workouts = try await workoutService.fetchWorkouts()
                
                self.loadingState = .data
            } catch {
                self.loadingState = .error
            }
        }
        
        // Exercises
        func fetchExercises() async {
            do {
                self.exercises = try await exerciseService.fetchExercises()
                self.loadingState = .data
            } catch {
                self.loadingState = .error
            }
        }
        
        
        // Instances
        func fetchInstances() async {
            do {
                self.instances = try await instanceService.fetchInstances()
                self.loadingState = .data
            } catch {
                self.loadingState = .error
            }
        }
        
        func findInstances(forExercise exercise: Exercise) -> [ExerciseInstance] {
            return self.instances.filter({ $0.exerciseId == exercise.id }).sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
        
        func deleteInstance(by id: String) async {
            do {
                // delete the ref to this instance in it's workout
                try await workoutService.deleteInstanceRef(id)
                
                try await instanceService.deleteInstance(id: id)
            } catch _ {}
        }
        
        
        // Workouts
        func fetchWorkouts() async {
            do {
                self.workouts = try await workoutService.fetchWorkouts()
                self.loadingState = .data
            } catch {
                self.loadingState = .error
            }
        }
        
        func deleteWorkout(workout: Workout) async {
            self.loadingState = .loading
            
            do {
                try await workoutService.deleteWorkout(id: workout.id!)
                
                for instanceId in workout.exerciseInstanceIdList {
                    try await instanceService.deleteInstance(id: instanceId)
                }
            } catch _ {}
        }
        
        
        // WorkoutHistoryItems
        func createItems(forWorkout workout: Workout) {
            var items = [WorkoutHistoryItem]()
            
            for id in workout.exerciseInstanceIdList {
                if let instance = self.instances.first(where: { $0.id == id }) {
                    if let exercise = self.exercises.first(where: { $0.id == instance.exerciseId }) {
                        items.append(WorkoutHistoryItem(exercise: exercise, instance: instance))
                    }
                }
            }
            
            self.historyItems = items
        }
        
    }
}
