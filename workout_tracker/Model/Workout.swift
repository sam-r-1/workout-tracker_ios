//
//  Workout.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import FirebaseFirestoreSwift
import Firebase

struct Workout: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let timestamp: Timestamp
    var exerciseInstanceIdList: [String]
    
    // initialize from code
    init(uid: String, timestamp: Timestamp, exerciseInstanceIdList: [String]) {
        self.uid = uid
        self.timestamp = timestamp
        self.exerciseInstanceIdList = exerciseInstanceIdList
    }
}
