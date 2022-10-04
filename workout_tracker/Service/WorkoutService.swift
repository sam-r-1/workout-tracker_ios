//
//  WorkoutService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct WorkoutService {
    
    // create a workout and post it to the database
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
    
    // fetch all of the user's workouts from the backend
    func fetchWorkouts(completion: @escaping([Workout]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("workouts")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                var workouts = documents.compactMap({ try? $0.data(as: Workout.self) })
                
                // add the id's
                for i in 0...(workouts.count - 1) {
                    workouts[i].id = documents[i].documentID
                }
                
                completion(workouts)
            }
    }
}
