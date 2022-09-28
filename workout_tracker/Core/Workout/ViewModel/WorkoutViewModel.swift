//
//  WorkoutViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import Foundation
import Firebase

class ExerciseInstanceViewModel: ObservableObject {
    @Published var open = true
    
    let timeFormatter: DateComponentsFormatter

    init() {
        timeFormatter = DateComponentsFormatter()
        timeFormatter.zeroFormattingBehavior = .dropLeading
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.allowsFractionalUnits = true
        timeFormatter.unitsStyle = .abbreviated
        
        print("DEBUG: init instance viewmodel")
    }
}

class ExerciseDataFields: Identifiable {
    init(parent: WorkoutViewModel, exercise: Exercise) {
        self.parent = parent
        self.exercise = exercise
    }
    
    let id = UUID()
    private let parent: WorkoutViewModel
    // let exerciseId: String
    let exercise: Exercise
    private let service = ExerciseService()
    
    var weight = 0.0 {
        didSet { self.parent.update() }
    }
    
    var reps = 0 {
        didSet { self.parent.update() }
    }
    
    var time = 0.0 {
        didSet { self.parent.update() }
    }
}

class WorkoutViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var userExercises = [Exercise]()
    @Published var exerciseInstances = [ExerciseInstance]()
    
    @Published var didUploadWorkout = false
    
    private let exerciseService = ExerciseService()
    private let workoutService = WorkoutService()
    private let instanceService = ExerciseInstanceService()
    
    @Published var items = [ExerciseDataFields]()
    
    func update() {
        self.objectWillChange.send()
    }
    
    func addItem(_ exerciseId: String) {
        fetchAndSetExerciseById(exerciseId) { exercise in
            self.items.append(ExerciseDataFields(parent: self, exercise: exercise))
        }
    }
    
    init() {
        fetchExercises()
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
        exerciseService.fetchExercises { exercises in
        self.userExercises = exercises
        }
    }
    
    private func fetchAndSetExerciseById(_ id: String, completion: @escaping (Exercise) -> Void) {
        exerciseService.fetchExerciseById(id: id) { exercise in
            completion(exercise)
        }
    }
    
    // Add the items the user has added to the workout to a list as [ExerciseInstance] for upload
    private func addExerciseToWorkout(_ item: ExerciseDataFields, uid: String) {
        exerciseInstances.append(ExerciseInstance(uid: uid, exerciseId: item.exercise.id!, timestamp: Timestamp(), reps: item.reps, time: item.time, weight: item.weight))
    }
    
    // upload the exercise instances to the database, returning a list of their id's in a closure
    private func uploadInstances(completion: @escaping ([String]) -> Void) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var idList: [String] = []
        var id: String
        
        // create exercise instances from the workout items
        for item in self.items {
            addExerciseToWorkout(item, uid: uid)
        }
        
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
                    self.didUploadWorkout = true
                } else {
                    // show error message to user
                }
            }
        }
    }
}
