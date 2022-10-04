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
    func fetchPreviousInstanceDataById(_ exerciseId: String, completion: @escaping(ExerciseInstance) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("exercise-instances")
            .whereField("uid", isEqualTo: uid)
            .whereField("exerciseId", isEqualTo: exerciseId)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                guard error == nil else {
                    print("DEBUG: \(error!.localizedDescription)")
                    return
                }
                
                let instances = snapshot!.documents.compactMap({ try? $0.data(as: ExerciseInstance.self) })
                
                guard let prevInstance = instances.first else { return }
                completion(prevInstance)
            }
    }
    
    // fetch a single exercise instances by its id
    func fetchInstances(byInstanceIdList instanceIdList: [String], completion: @escaping([ExerciseInstance]) -> Void) {
        var instances = [ExerciseInstance]()
        
        instanceIdList.forEach { id in
            
            Firestore.firestore().collection("exercise-instances").document(id)
                .getDocument { snapshot, _ in
                    guard let instance = try? snapshot?.data(as: ExerciseInstance.self) else { return }
                    instances.append(instance)
                    
                    completion(instances)
                }
        }
    }
}
