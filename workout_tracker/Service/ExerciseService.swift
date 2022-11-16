//
//  ExerciseService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation
import Firebase

struct ExerciseService {
    
    // create/edit an exercise and post it
    func setExercise(id: String? = nil, name: String, type: String, details: String, includeWeight: Bool, includeReps: Bool, includeTime: Bool, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "name": name,
                    "type": type,
                    "details": details,
                    "includeWeight": includeWeight,
                    "includeReps": includeReps,
                    "includeTime": includeTime] as [String: Any]
        
        let collectionRef = Firestore.firestore().collection("exercises")
        
        // if an id is provided, set the ref to that location, otherwise give a blank one
        let ref: DocumentReference
        if id != nil {
            ref = collectionRef.document(id!)
        } else {
            ref = collectionRef.document()
        }
        
        ref.setData(data) { error in
            if let error = error {
                print("DEBUG: Failed to upload exercise with error \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    // fetch a specific exercise from the backend by its ID
    func fetchExerciseById(id: String, completion: @escaping(Exercise) -> Void) {       
        Firestore.firestore().collection("exercises").document(id)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                
                guard let exercise = try? snapshot.data(as: Exercise.self) else { return }
                completion(exercise)
            }
    }
    
    // fetch exercises given an id list
    func fetchExercises(byIdList idList: [String]) async throws -> [Exercise] {
        var exercises = Array(repeating: Exercise(uid: "", name: "", type: "", details: "", includeWeight: false, includeReps: false, includeTime: false), count: idList.count)
        
        let collectionRef = Firestore.firestore().collection("exercises")
        
        for i in 0..<idList.count {
            let exercise = try await collectionRef.document(idList[i])
                .getDocument(as: Exercise.self)
            
            exercises[i] = exercise
        }
        
        return(exercises)
    }
    
    // fetch all of the user's exercises from the backend
    func fetchExercises(completion: @escaping([Exercise]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("exercises")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                var exercises = documents.compactMap({ try? $0.data(as: Exercise.self) })
                
                // add the id's
                if exercises.count >= 1 {
                    for i in 0..<exercises.count {
                        exercises[i].id = documents[i].documentID
                    }
                }
                
                completion(exercises.sorted(by: { $0.name < $1.name }))
            }
    }
    
    // Delete an exercise from the backend
    func deleteExercise(id: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("exercises").document(id)
            .delete { error in
                guard error == nil else {
                    print("DEBUG: \(error!.localizedDescription)")
                    return
                }
                
                completion(true)
            }
    }
}
