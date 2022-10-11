//
//  WorkoutDetailsViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import Foundation

class WorkoutDetailsViewModel: ObservableObject {
    @Published var exerciseInstances = [ExerciseInstance]()
    private let service = ExerciseInstanceService()
    
    init(_ workout: Workout) {
        fetchInstancesFromIdList(workout.exerciseInstanceIdList)
    }
    
    func fetchInstancesFromIdList(_ instanceIdList: [String]) {
        service.fetchInstances(byInstanceIdList: instanceIdList) { instances in
            self.exerciseInstances = instances
        }
    }
    
    // delete an instance from both the local and backend
    func deleteInstance(by id: String) {
        service.deleteInstances(fromInstanceIdList: [id]) // delete from Firebase
        
        self.exerciseInstances.remove(at: self.exerciseInstances.firstIndex(where: { $0.id == id })!) // delete from local
    }
}
