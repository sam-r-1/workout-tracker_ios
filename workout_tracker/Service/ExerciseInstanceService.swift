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
    func fetchMostRecentInstance(byExerciseId exerciseId: String, completion: @escaping(ExerciseInstance) -> Void) {
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
    
    // fetch a list of exercise instances using their id's
    func fetchInstances(byInstanceIdList instanceIdList: [String]) async throws -> [ExerciseInstance] {
        var instances = Array(repeating: ExerciseInstance(uid: "", exerciseId: "", timestamp: Timestamp(), reps: 0, time: 0, weight: 0), count: instanceIdList.count)

        let collectionRef = Firestore.firestore().collection("exercise-instances")
        
        for i in 0..<instanceIdList.count {
            let instance = try await collectionRef.document(instanceIdList[i])
                .getDocument(as: ExerciseInstance.self)
            
            instances[i] = instance
        }
        
        return instances
    }
    
    func fetchInstances(byExerciseId id: String, completion: @escaping([ExerciseInstance]) -> Void) {
        Firestore.firestore().collection("exercise-instances")
            .whereField("exerciseId", isEqualTo: id)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let instances = documents.compactMap({ try? $0.data(as: ExerciseInstance.self) })
                
                completion(instances.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }))
            }
    }
    
    // Delete instances of an exercise from the database based on a list of instances
    // to be used for deleting all data associated with a workout
    func deleteInstances(fromInstanceIdList idList: [String]) {
        let workoutService = WorkoutService()
        
        idList.forEach { id in
            Firestore.firestore().collection("exercise-instances").document(id)
                .delete()
            
            workoutService.deleteInstanceRef(id)
        }
    }
    
    // Delete all instances of an [Exercise] given it's ID
    func deleteInstances(ofExercise exerciseId: String) {
        let workoutService = WorkoutService()
        
        let query = Firestore.firestore().collection("exercise-instances")
            .whereField("exerciseId", isEqualTo: exerciseId)
        
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
            
            let documents = snapshot!.documents
            
            documents.forEach { doc in
                let id = doc.reference.documentID
                
                // delete the instances
                doc.reference.delete()
                
                // remove the instances from the associated workouts
                workoutService.deleteInstanceRef(id)
            }
        }
    }
}
