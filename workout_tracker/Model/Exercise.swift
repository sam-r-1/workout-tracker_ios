//
//  Exercise.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import FirebaseFirestoreSwift
import Firebase

struct Exercise: Identifiable, Decodable {
    @DocumentID var id: String?
    let name: String
    let type: String
    let includeReps: Bool
    let includeTime: Bool

    // var user: User?
}
