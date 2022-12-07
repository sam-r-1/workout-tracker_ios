//
//  Exercise.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct Exercise: Identifiable, Decodable, Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    let uid: String
    let name: String
    let type: String
    let details: String
    let includeWeight: Bool
    let includeReps: Bool
    let includeTime: Bool

    // Returns a string listing the data fields that this exercise uses. To be used in the ExerciseRowView
    func dataFieldIcons() -> some View {
        return Group {
            if self.includeWeight {
                DataFieldIcons.weight
            }
            if self.includeReps {
                DataFieldIcons.reps
            }
            if self.includeTime {
                DataFieldIcons.time
            }
        }
    }
}
