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
    
    func fetchExercises() async {
        do {
            self.exercises = try await service.fetchExercises()
            self.loadingState = .data
        } catch {
            debugPrint(error.localizedDescription)
            self.loadingState = .error
        }
    }
}
