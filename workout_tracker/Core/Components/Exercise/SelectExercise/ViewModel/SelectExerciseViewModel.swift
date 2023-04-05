//
//  SelectExerciseViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation

extension SelectExerciseView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var loadingState = LoadingState.loading
        @Published var searchText = ""
        @Published var userExercises = [Exercise]()
        let service = RealExerciseService()
        
        // Allow the user to filter their exercises by title or type
        var searchableExercises: [Exercise] {
            if searchText.isEmpty {
                return userExercises
            } else {
                let lowercasedQuery = searchText.lowercased()
                
                return userExercises.filter({
                    $0.name.lowercased().contains(lowercasedQuery) || $0.type.lowercased().contains(lowercasedQuery)
                })
            }
        }
        
        // Fetch the list of the user's exercises for selection
        func fetchExercises() async {
            do {
                self.userExercises = try await service.fetchExercises()
                self.loadingState = .data
            } catch {
                debugPrint(error.localizedDescription)
                self.loadingState = .error
            }
        }
    }
    
}
