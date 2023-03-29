//
//  WorkoutService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct WorkoutService {
    private let db = Firestore.firestore()
    
    // create a workout and post it to the database
    func uploadWorkout(exerciseInstanceIdList: [String]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw WorkoutServiceError.authenticationError }
        
        let data = ["uid": uid,
                    "timestamp": Timestamp(),
                    "exerciseInstanceIdList": exerciseInstanceIdList] as [String: Any]
        
        let ref = db.collection("workouts").document()
        
        do {
            try await ref.setData(data)
        } catch {
            throw WorkoutServiceError.setDataError
        }
    }
    
    // fetch all of the user's workouts from the backend
    func fetchWorkouts(completion: @escaping([Workout]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("workouts")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let workouts = documents.compactMap({ try? $0.data(as: Workout.self) })
                
                completion(workouts)
            }
    }
    
    // Delete a workout from the backend
    func deleteWorkout(id: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("workouts").document(id)
            .delete { error in
                guard error == nil else {
                    print("DEBUG: \(error!.localizedDescription)")
                    return
                }
                
                completion(true)
            }
    }
    
    // Remove instance id's from the workout's instanceIdList property. Use after the instances themselves are deleted
    func deleteInstanceRef(_ id: String) {
        let query = Firestore.firestore().collection("workouts")
            .whereField("exerciseInstanceIdList", arrayContains: id)
        
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
            
            let documents = snapshot!.documents
            
            documents.forEach { doc in
                doc.reference.updateData(["exerciseInstanceIdList": FieldValue.arrayRemove([id])]) { error in
                    guard error == nil else {
                        print("DEBUG: \(error!.localizedDescription)")
                        return
                    }
                    
                    // check if the workout has any remaining instances. If it doesn't, delete it
                    doc.reference.getDocument { snapshot, _ in
                        guard let snapshot = snapshot else { return }
                        
                        guard let workout = try? snapshot.data(as: Workout.self) else { return }
                        
                        if workout.exerciseInstanceIdList.count == 0 { doc.reference.delete() }
                    }
                }
            }
        }
    }
}

extension WorkoutService {
    enum WorkoutServiceError: Error {
        case authenticationError
        case dataFetchingError
        case setDataError
    }
}
