//
//  WorkoutDetailsViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import Foundation

//class ExerciseResults: Identifiable {
//    init(instance: ExerciseInstance, exercise: Exercise) {
//        self.instance = instance
//        self.exercise = exercise
//    }
//
//    let id = UUID()
//    let instance: ExerciseInstance
//    let exercise: Exercise
//}

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
}
