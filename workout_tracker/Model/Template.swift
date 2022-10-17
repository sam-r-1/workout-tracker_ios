//
//  Template.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import FirebaseFirestoreSwift
import Firebase

struct Template: Identifiable, Decodable {
    @DocumentID var id: String?
    let uid: String
    let name: String
    let timestamp: Timestamp
    var exerciseList: [String]
    
    enum CodingKeys: String, CodingKey {
        case uid, name, timestamp, exerciseList
    }
    
    // initialize from Firebase
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
        exerciseList = try container.decode([String].self, forKey: .exerciseList)
    }
    
    // initialize from code
    init(uid: String, name: String, timestamp: Timestamp, exerciseList: [String]) {
        self.uid = uid
        self.name = name
        self.timestamp = timestamp
        self.exerciseList = exerciseList
    }
}
