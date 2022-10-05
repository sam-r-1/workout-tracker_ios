//
//  HistoryViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var workouts = [Workout]()
    private let service = WorkoutService()
    private let instanceService = ExerciseInstanceService()
    
    init() {
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        service.fetchWorkouts { workouts in
            self.workouts = workouts
        }
    }
    
    // delete a workout and its associated [ExerciseInstance]'s from the backend and frontend
    func deleteWorkout(workout: Workout) {
        service.deleteWorkout(id: workout.id!) { success in
            if success {
                // delete associated instances
                self.instanceService.deleteInstances(fromInstanceIdList: workout.exerciseInstanceIdList)
                
                // delete from local memory
                self.workouts.removeAll { thisWorkout in
                    thisWorkout.id == workout.id
                }
            }
        }
    }
}