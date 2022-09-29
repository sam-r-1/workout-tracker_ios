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
    
    enum DownloadError: Error {
        case authenticationError, downloadFailed
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
    
    // fetch the previous exercise instance for a given exercise, returning the weight and rep count
    func fetchPreviousInstanceDataById(_ exerciseId: String) async throws -> (ExerciseInstance?) {
        guard let uid = Auth.auth().currentUser?.uid else { throw DownloadError.authenticationError }
        
        let snapshot = try await Firestore.firestore().collection("exercise-instances")
            .whereField("uid", isEqualTo: uid)
            .whereField("exerciseId", isEqualTo: exerciseId)
            // .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments()
        
        let documents = snapshot.documents
        
        let instances = documents.compactMap({ try? $0.data(as: ExerciseInstance.self) })
        
        return instances.first
        
    }
}
