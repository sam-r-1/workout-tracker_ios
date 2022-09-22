//
//  ExerciseInstanceService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct ExerciseInstanceService {
    
    // post an exercise instance to the database
//    func uploadInstance(_ instance: ExerciseInstance, completion: @escaping(Bool, String) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let data = ["uid": uid,
//                    "exerciseId": instance.exerciseId,
//                    "timestamp": instance.timestamp,
//                    "repCount": instance.repCount,
//                    "time": instance.time,
//                    "weight": instance.weight,
//                    ] as [String: Any]
//
//        let ref = Firestore.firestore().collection("exercise-instances").document()
//
//        ref.setData(data) { error in
//                if let error = error {
//                    print("DEBUG: Failed to upload exercise instance with error \(error.localizedDescription)")
//                    completion(false, "")
//                    return
//                }
//            completion(true, ref.documentID)
//            }
//    }
    
    enum UploadError: Error {
        case authenticationError, uploadFailed
    }
    
    func uploadInstance(_ instance: ExerciseInstance) async throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else { throw UploadError.authenticationError }
        
        let data = ["uid": uid,
                    "exerciseId": instance.exerciseId,
                    "timestamp": instance.timestamp,
                    "repCount": instance.repCount,
                    "time": instance.time,
                    "weight": instance.weight,
                    ] as [String: Any]
    
        let ref = Firestore.firestore().collection("exercise-instances").document()

        try await ref.setData(data)
        
        return ref.documentID
    }
}
