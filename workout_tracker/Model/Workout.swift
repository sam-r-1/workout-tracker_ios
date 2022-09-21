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
    
    enum CodingKeys: String, CodingKey {
        case uid, timestamp, exerciseInstanceIdList
    }
    
    // initialize from Firebase
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
        exerciseInstanceIdList = try container.decode([String].self, forKey: .exerciseInstanceIdList)
    }
    
    // initialize from code
    init(uid: String, timestamp: Timestamp, exerciseInstanceIdList: [String]) {
        self.uid = uid
        self.timestamp = timestamp
        self.exerciseInstanceIdList = exerciseInstanceIdList
    }
}
