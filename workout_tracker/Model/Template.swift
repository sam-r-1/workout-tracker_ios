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
    var exerciseIdList: [String]
    var exerciseNameList: [String]
    
    // initialize from code
    init(uid: String, name: String, exerciseIdList: [String], exerciseNameList: [String]) {
        self.uid = uid
        self.name = name
        self.timestamp = Timestamp()
        self.exerciseIdList = exerciseIdList
        self.exerciseNameList = exerciseNameList
    }
}
