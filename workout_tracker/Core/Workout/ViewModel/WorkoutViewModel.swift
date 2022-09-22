//
//  WorkoutViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import Foundation
import Firebase

class ExerciseInstanceViewModel: ObservableObject {
    @Published var exercise: Exercise? = nil
    
    @Published var weight = 0.0
    @Published var reps: Int = 0
    @Published var time = 0.0
    @Published var formattedTimeString = "0:00"
    
    @Published var open = true
    
    @Published var showWeight = true
    @Published var showReps = false
    @Published var showTime = false
    
    let formatter: DateComponentsFormatter
    
    private let service = ExerciseService()
    
    init(_ id: String) {
        formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.allowedUnits = [.minute, .second]
        formatter.allowsFractionalUnits = true
        formatter.unitsStyle = .abbreviated
        
        fetchExerciseById(id)
    }
    
    func updateTime(_ newTime: Double) {
        self.time = newTime
        formattedTimeString = formatter.string(from: time)!
    }
    
    func fetchExerciseById(_ id: String) {
        service.fetchExerciseById(id: id) { exercise in
            self.exercise = exercise
            
            self.fetchFields()
        }
    }
    
    // check the exercise template and show the appropriate fields
    func fetchFields() {
        if exercise != nil {
            self.showWeight = exercise!.includeWeight
            self.showReps = exercise!.includeReps
            self.showTime = exercise!.includeTime
        } else { print("DEBUG: exercise is nil") }
        
    }
}

class WorkoutViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var exercises = [Exercise]()
    @Published var exerciseInstances = [ExerciseInstance]()
    
    @Published var didCreateWorkout = false
    
    private let exerciseService = ExerciseService()
    // private let userService = UserService()
    private let workoutService = WorkoutService()
    private let instanceService = ExerciseInstanceService()
    
    
    init() {
        fetchExercises()
    }
    
    func addExerciseToWorkout(_ exerciseId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        exerciseInstances.append(ExerciseInstance(uid: uid, exerciseId: exerciseId, timestamp: Timestamp(date: Date()), repCount: 0, time: 0.0, weight: 0, open: true))
    }
    
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
    
    func fetchExercises() {
        exerciseService.fetchExercises { exercises in
        self.exercises = exercises
        }
    }
    
    // upload the exercise instances to the database, returning a list of their id's in a closure
    func uploadInstances(completion: @escaping ([String]) -> Void) async {
        var idList: [String] = []
        var id: String
        
        // upload the individual exercise data
        for instance in self.exerciseInstances {
            
            do {
                id = try await instanceService.uploadInstance(instance)
                idList.append(id)
            } catch _ {}
            
        }
        completion(idList)
    }
    
    func finishWorkout() async {
        
        await uploadInstances { idList in
            print(idList)
            
            self.workoutService.uploadWorkout(exerciseInstanceIdList: idList) { success in
                if success {
                    // dismiss workout screen
                    self.didCreateWorkout = true
                } else {
                    // show error message to user
                }
            }
        }
    }
}
