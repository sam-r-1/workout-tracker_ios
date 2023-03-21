//
//  ExerciseInstance.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/17/22.
//

import FirebaseFirestoreSwift
import Firebase

struct ExerciseInstance: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let exerciseId: String
    let timestamp: Timestamp
    var reps: Int
    var time: Double // time in seconds
    var weight: Double
    
    // initialize from code
    init(uid: String, exerciseId: String, timestamp: Timestamp, reps: Int, time: Double, weight: Double) {
        self.uid = uid
        self.exerciseId = exerciseId
        self.timestamp = timestamp
        self.reps = reps
        self.time = time
        self.weight = weight
    }
}
