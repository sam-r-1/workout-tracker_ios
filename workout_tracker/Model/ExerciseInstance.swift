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
    let exerciseID: String
    let timestamp: Timestamp
    var repCount: Int
    var time: Double // time in seconds
    var weight: Double
    var open: Bool
    
    enum CodingKeys: String, CodingKey {
        case uid, exerciseID, timestamp, repCount, time, weight, open
    }
    
    // Initialize from Firebase
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        exerciseID = try container.decode(String.self, forKey: .exerciseID)
        timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
        repCount = try container.decode(Int.self, forKey: .repCount)
        time = try container.decode(Double.self, forKey: .time)
        weight = try container.decode(Double.self, forKey: .weight)
        do {
            open = try container.decode(Bool.self, forKey: .open)
        } catch {
            open = false
        }
    }
    
    // initialize from code
    init(uid: String, exerciseID: String, timestamp: Timestamp, repCount: Int, time: Double, weight: Double, open: Bool) {
        self.uid = uid
        self.exerciseID = exerciseID
        self.timestamp = timestamp
        self.repCount = repCount
        self.time = time
        self.weight = weight
        self.open = open
    }
}
