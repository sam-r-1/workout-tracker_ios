//
//  WorkoutViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import Foundation
import Firebase

class WorkoutViewModel: ObservableObject {
    @Published var time = 0.0
    @Published var formattedTimeString = "0:00"
    @Published var open = false
    let formatter: DateComponentsFormatter
    
    init() {
        formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.allowedUnits = [.minute, .second]
        formatter.allowsFractionalUnits = true
        formatter.unitsStyle = .abbreviated
    }
    
    func updateTime(_ newTime: Double) {
        self.time = newTime
        formattedTimeString = formatter.string(from: time)!
    }
}

class ExerciseInstancesViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var exercises = [Exercise]()
    @Published var exerciseInstances = [ExerciseInstance]()
    
    private let service = ExerciseService()
    private let userService = UserService()
    
    
    init() {
        fetchExercises()
    }
    
    func addExerciseToWorkout(_ exerciseID: String) {
        exerciseInstances.append(ExerciseInstance(uid: "uid", exerciseID: exerciseID, timestamp: Timestamp(date: Date()), repCount: 0, time: 0.0, weight: 0, open: true))
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
        service.fetchExercises { exercises in
        self.exercises = exercises
        }
    }
}
