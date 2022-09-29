//
//  ExerciseService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation
import Firebase

struct ExerciseService {
    
    // create an exercise and post it
    func createExercise(name: String, type: String, details: String, includeWeight: Bool, includeReps: Bool, includeTime: Bool, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "name": name,
                    "type": type,
                    "details": details,
                    "includeWeight": includeWeight,
                    "includeReps": includeReps,
                    "includeTime": includeTime] as [String: Any]
        
        Firestore.firestore().collection("exercises").document()
            .setData(data) { error in
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
    
    // fetch all of the user's exercises from the backend
    func fetchExercises(completion: @escaping([Exercise]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("exercises")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let exercises = documents.compactMap({ try? $0.data(as: Exercise.self) })
                completion(exercises.sorted(by: { $0.name < $1.name }))
            }
    }
}
