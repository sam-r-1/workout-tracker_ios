//
//  ExerciseInstanceService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct ExerciseInstanceService {
    
    // post an exercise instance to the database
    func uploadInstance(_ instance: ExerciseInstance, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "exerciseId": instance.exerciseId,
                    "timestamp": instance.timestamp,
                    "repCount": instance.repCount,
                    "time": instance.time,
                    "weight": instance.weight,
                    ] as [String: Any]
        
        Firestore.firestore().collection("exercise-instances").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload exercise instance with error \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
}
