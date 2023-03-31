//
//  ExerciseInstanceService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/21/22.
//

import Foundation
import Firebase

struct ExerciseInstanceService {
    private let db = Firestore.firestore()
    
    func uploadInstances(_ instances: [ExerciseInstance]) async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { throw ExerciseInstanceServiceError.authenticationError }
        
        var instanceIdList = [String]()
        
        for instance in instances {
            let data = ["uid": uid,
                        "exerciseId": instance.exerciseId,
                        "timestamp": instance.timestamp,
                        "reps": instance.reps,
                        "time": instance.time,
                        "weight": instance.weight,
                        ] as [String: Any]
            
            let ref = db.collection("exercise-instances").document()
            
            do {
                try await ref.setData(data)
            } catch {
                throw ExerciseInstanceServiceError.setDataError
            }
            
            instanceIdList.append(ref.documentID)
        }
        
        return instanceIdList
    }

    func fetchMostRecentInstance(byExerciseId exerciseId: String) async throws -> ExerciseInstance {
        guard let uid = Auth.auth().currentUser?.uid else { throw ExerciseInstanceServiceError.authenticationError }
        
        do {
            let snapshot = try await db.collection("exercise-instances")
                .whereField("uid", isEqualTo: uid)
                .whereField("exerciseId", isEqualTo: exerciseId)
                .order(by: "timestamp", descending: true)
                .limit(to: 1)
                .getDocuments()
            
            let instance = snapshot.documents.compactMap({ try? $0.data(as: ExerciseInstance.self) })
            
            guard instance.count == 1 else { throw ExerciseInstanceServiceError.dataFetchingError }
            
            return instance.first!
        } catch {
            throw  ExerciseInstanceServiceError.dataFetchingError
        }
    }
    
    // fetch all of the user's instances
    func fetchInstances() async throws -> [ExerciseInstance] {
        guard let uid = Auth.auth().currentUser?.uid else { throw ExerciseInstanceServiceError.authenticationError }
        
        do {
            let snapshot = try await db.collection("exercise-instances")
                .whereField("uid", isEqualTo: uid)
                .getDocuments()
            
            let instances = snapshot.documents.compactMap({ try? $0.data(as: ExerciseInstance.self) })
            
            return instances
        } catch {
            throw ExerciseInstanceServiceError.dataFetchingError
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
    
    func fetchInstances(byExerciseId id: String) async throws -> [ExerciseInstance] {
        
        do {
            let snapshot = try await db.collection("exercise-instances")
                .whereField("exerciseId", isEqualTo: id)
                .getDocuments()
            
            let instances = snapshot.documents.compactMap({ try? $0.data(as: ExerciseInstance.self) })
            
            return instances.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        } catch {
            throw ExerciseInstanceServiceError.dataFetchingError
        }
    }
    
    func deleteInstance(id: String) async throws {
        do {
            try await db.collection("exercise-instances").document(id).delete()
        } catch {
            throw ExerciseInstanceServiceError.setDataError
        }
    }
    
    // Delete all instances of an [Exercise] given it's ID
    func deleteInstances(ofExercise exerciseId: String) async throws {
        let workoutService = WorkoutService()
        
        let query = db.collection("exercise-instances")
            .whereField("exerciseId", isEqualTo: exerciseId)
        
        do {
            let documents = try await query.getDocuments().documents
            
            for doc in documents {
                let id = doc.reference.documentID
                
                try await doc.reference.delete()
                
                try await workoutService.deleteInstanceRef(id)
            }
        } catch {
            throw ExerciseInstanceServiceError.setDataError
        }
    }
}

extension ExerciseInstanceService {
    enum ExerciseInstanceServiceError: Error {
        case authenticationError
        case dataFetchingError
        case setDataError
    }
}
