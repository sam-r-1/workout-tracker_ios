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
    
    // delete an instance from both the local and backend
    func deleteInstance(by id: String) {
        service.deleteInstances(fromInstanceIdList: [id]) // delete from Firebase
        
        self.exerciseInstances.remove(at: self.exerciseInstances.firstIndex(where: { $0.id == id })!) // delete from local
    }
}
