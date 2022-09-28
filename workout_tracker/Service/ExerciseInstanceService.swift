//
//  ExerciseInstanceService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct ExerciseInstanceService {
    
    enum UploadError: Error {
        case authenticationError, uploadFailed
    }
    
    func uploadInstance(_ instance: ExerciseInstance) async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else { throw UploadError.authenticationError }
        
        let data = ["uid": uid,
                    "exerciseId": instance.exerciseId,
                    "timestamp": instance.timestamp,
                    "reps": instance.reps,
                    "time": instance.time,
                    "weight": instance.weight,
                    ] as [String: Any]
    
        let ref = Firestore.firestore().collection("exercise-instances").document()

        try await ref.setData(data)
        
        return ref.documentID
    }
}
