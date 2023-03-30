//
//  HistoryByWorkoutViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import Foundation

extension HistoryByWorkoutView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var loadingState = LoadingState.loading
        @Published var workouts = [Workout]()
        
        private let service = WorkoutService()
        private let instanceService = ExerciseInstanceService()
        
        func fetchWorkouts() async {
            do {
                self.workouts = try await service.fetchWorkouts()
                self.loadingState = .data
            } catch {
                self.loadingState = .error
            }
        }
        
        // delete a workout and its associated [ExerciseInstance]'s from the backend and frontend
        func deleteWorkout(workout: Workout) async {
            do {
                try await service.deleteWorkout(id: workout.id!)
                
                for instanceId in workout.exerciseInstanceIdList {
                    try await instanceService.deleteInstance(id: instanceId)
                }
            } catch _ {}
        }
    }
}
