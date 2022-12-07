//
//  SelectExerciseViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation

class SelectExerciseViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var userExercises = [Exercise]()
    let service = ExerciseService()
    
    init(forPreview: Bool = false) {
        if forPreview {
            self.userExercises = MockService.sampleExercises
        } else {
            fetchExercises()
        }
    }
    
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
        private func fetchExercises() {
            service.fetchExercises { exercises in
            self.userExercises = exercises
            }
        }
 }
