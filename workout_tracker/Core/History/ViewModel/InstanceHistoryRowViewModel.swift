//
//  InstanceHistoryRowViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import Foundation

class InstanceHistoryRowViewModel: ObservableObject {
    @Published var exercise: Exercise?
    private let service = ExerciseService()
    
    init(fromExerciseId exerciseId: String) {
        fetchExerciseById(exerciseId)
    }
    
    private func fetchExerciseById(_ id: String) {
        service.fetchExerciseById(id: id) { exercise in
            self.exercise = exercise
        }
    }
}
