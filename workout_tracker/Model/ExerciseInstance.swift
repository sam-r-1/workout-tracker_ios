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
    
    enum CodingKeys: String, CodingKey {
        case uid, exerciseId, timestamp, reps, time, weight
    }
    
    // Initialize from Firebase
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        exerciseId = try container.decode(String.self, forKey: .exerciseId)
        timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
        reps = try container.decode(Int.self, forKey: .reps)
        time = try container.decode(Double.self, forKey: .time)
        weight = try container.decode(Double.self, forKey: .weight)
    }
    
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
