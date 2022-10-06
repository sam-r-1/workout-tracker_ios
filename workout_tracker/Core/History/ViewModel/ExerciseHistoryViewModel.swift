//
//  ExerciseHistoryViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import Foundation

class ExerciseHistoryViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var loadingState = LoadingState.loading
    private let service = ExerciseService()
    
    init() {
        fetchExercises()
    }
    
    func fetchExercises() {
        service.fetchExercises { exercises in
            self.exercises = exercises
            self.loadingState = .data
        }
    }
}
