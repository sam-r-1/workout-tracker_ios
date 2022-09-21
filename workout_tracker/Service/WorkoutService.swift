//
//  WorkoutService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct WorkoutService {
    
    // post a workout to the database
    func uploadWorkout(exerciseInstanceIdList: [String], completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "timestamp": Timestamp(),
                    "exerciseInstanceIdList": exerciseInstanceIdList] as [String: Any]
        
        Firestore.firestore().collection("workouts").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload workout with error \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
}
