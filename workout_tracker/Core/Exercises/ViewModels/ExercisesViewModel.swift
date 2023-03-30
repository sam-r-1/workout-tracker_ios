//
//  ExercisesViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import Foundation

extension ExercisesView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var loadingState = LoadingState.loading
        @Published var searchText = ""
        @Published var exercises = [Exercise]()
        private let service = ExerciseService()
        private let userService = UserService()
        
        // Allow the user to filter their exercises by title or type
        var searchableExercises: [Exercise] {
            if searchText.isEmpty {
                return exercises
            } else {
                let lowercasedQuery = searchText.lowercased()
                
                return exercises.filter({
                    $0.name.lowercased().contains(lowercasedQuery) || $0.type.lowercased().contains(lowercasedQuery)
                })
            }
        }
        
        func fetchExercises() async {
            do {
                self.exercises = try await service.fetchExercises()
                self.loadingState = .data
            } catch {
                self.loadingState = .error
            }
        }
    }
    
}
