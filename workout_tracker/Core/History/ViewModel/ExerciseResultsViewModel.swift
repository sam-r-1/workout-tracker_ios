//
//  ExerciseResultsViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import Foundation

class ExerciseResultsViewModel: ObservableObject {
    @Published var exerciseInstances = [ExerciseInstance]()
    private let service = ExerciseInstanceService()
    
    init(_ exercise: Exercise) {
        fetchInstancesFromIdList(exercise.id!)
    }
    
    func fetchInstancesFromIdList(_ exerciseId: String) {
        service.fetchInstances(byExerciseId: exerciseId) { instances in
            self.exerciseInstances = instances
        }
    }
}
