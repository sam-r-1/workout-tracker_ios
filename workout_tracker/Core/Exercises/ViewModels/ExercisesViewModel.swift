//
//  ExercisesViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import Foundation

class ExercisesViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var exercises = [Exercise]()
    private let service = ExerciseService()
    private let userService = UserService()
    
    init() {
        fetchExercises()
    }
    
    func fetchExercises() {
        service.fetchExercises { exercises in
            self.exercises = exercises
        }
    }
}
