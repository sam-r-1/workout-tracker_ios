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
    let uid: String
    let name: String
    let type: String
    let details: String
    let includeWeight: Bool
    let includeReps: Bool
    let includeTime: Bool

    func dataFieldTextList() -> String {
        var text = ""
        var count = 0
        
        if self.includeWeight {
            text += "Weight"
            count += 1
        }
        if self.includeReps {
            if count != 0 {
                text += ", Reps"
            } else {
                text += "Reps"
            }
        }
        if self.includeTime {
            if count != 0 {
                text += ", Time"
            } else {
                text += "Time"
            }
        }
        
        return text
    }
}
