//
//  WorkoutViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import Foundation
import Firebase

class ExerciseDataFields: Identifiable, Equatable {
    static func == (lhs: ExerciseDataFields, rhs: ExerciseDataFields) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(parent: WorkoutViewModel, exercise: Exercise) {
        self.parent = parent
        self.exercise = exercise
    }
    
    let id = UUID()
    private let parent: WorkoutViewModel
    let exercise: Exercise
    let instanceService = ExerciseInstanceService()
    
    var weight: Double = 0.0 {
        didSet { self.parent.update() }
    }
    
    var reps: Int = 0 {
        didSet { self.parent.update() }
    }
    
    var time: Double = 0.0 {
        didSet { self.parent.update() }
    }
    
    var previousInstance: ExerciseInstance? = nil {
        didSet { self.parent.update() }
    }
    
    func fetchPreviousInstance() {
        instanceService.fetchMostRecentInstance(byExerciseId: self.exercise.id!) { instance in
            self.previousInstance = instance
        }
    }
}

@MainActor
class WorkoutViewModel: ObservableObject {

    @Published var didUploadWorkout = false
    @Published var isUploadingWorkout = false
    private var exerciseInstances = [ExerciseInstance]()
    
    private let exerciseService = ExerciseService()
    private let workoutService = WorkoutService()
    private let instanceService = ExerciseInstanceService()
    
    @Published var items = [ExerciseDataFields]()

    
    nonisolated func update() {
        self.objectWillChange.send()
    }
    
    func addItem(_ exerciseId: String) {
        fetchAndSetExerciseById(exerciseId) { exercise in
            self.items.append(ExerciseDataFields(parent: self, exercise: exercise))
        }
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        self.items.move(fromOffsets: source, toOffset: destination)
    }
    
    func addExercisesFromTemplate(_ template: Template) async {
        do {
            let exercises = try await exerciseService.fetchExercises(byIdList: template.exerciseIdList)
            
            for exercise in exercises {
                self.items.append(ExerciseDataFields(parent: self, exercise: exercise))
            }
        } catch _ {}
    }
    
    private func fetchAndSetExerciseById(_ id: String, completion: @escaping (Exercise) -> Void) {
        exerciseService.fetchExerciseById(id: id) { exercise in
            completion(exercise)
        }
    }
    
    private func addExerciseToWorkout(_ item: ExerciseDataFields, uid: String) {
        exerciseInstances.append(ExerciseInstance(uid: uid, exerciseId: item.exercise.id!, timestamp: Timestamp(), reps: item.reps, time: item.time, weight: item.weight))
    }
    
    // upload the exercise instances to the database, returning a list of their id's in a closure
    private func uploadInstances(completion: @escaping ([String]) -> Void) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var idList: [String] = []
        var id: String
        
        self.exerciseInstances = []
        
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
        self.isUploadingWorkout = true
        
        await uploadInstances { idList in
            
            self.workoutService.uploadWorkout(exerciseInstanceIdList: idList) { success in
                self.isUploadingWorkout = false
                
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
