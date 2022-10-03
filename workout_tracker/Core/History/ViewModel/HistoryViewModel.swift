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
    
    init() {
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        service.fetchWorkouts { workouts in
            self.workouts = workouts
        }
    }
}
