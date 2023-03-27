//
//  ExerciseService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import Foundation
import Firebase

struct ExerciseService {
    private let db = Firestore.firestore()
    
    // create/edit an exercise and post it
    func setExercise(id: String? = nil, name: String, type: String, details: String, includeWeight: Bool, includeReps: Bool, includeTime: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw ExerciseServiceError.authenticationError }
        
        let data = ["uid": uid,
                    "name": name,
                    "type": type,
                    "details": details,
                    "includeWeight": includeWeight,
                    "includeReps": includeReps,
                    "includeTime": includeTime] as [String: Any]
        
        let collectionRef = db.collection("exercises")
        
        // if an id is provided, set the ref to that location, otherwise give a blank one
        let ref: DocumentReference
        if id != nil {
            ref = collectionRef.document(id!)
        } else {
            ref = collectionRef.document()
        }
        
        do {
            try await ref.setData(data)
        } catch {
            throw ExerciseServiceError.setDataError
        }
    }
    
    // fetch a specific exercise from the backend by its ID
    func fetchExerciseById(id: String, completion: @escaping(Exercise) -> Void) {
        debugPrint("DEBUG: Delete fetchExerciseById function with closure")
        
        db.collection("exercises").document(id)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                
                guard let exercise = try? snapshot.data(as: Exercise.self) else { return }
                completion(exercise)
            }
    }
    
    func fetchExerciseById(id: String) async throws -> Exercise {
        do {
            return try await db.collection("exercises").document(id)
                .getDocument(as: Exercise.self)
        } catch {
            throw ExerciseServiceError.dataFetchingError
        }
    }
    
    // fetch exercises given an id list
    func fetchExercises(fromIdList idList: [String]) async throws -> [Exercise] {
        var exercises = [Exercise]()
        
        let ref = db.collection("exercises")

        for id in idList {
            do {
                exercises.append(try await ref.document(id).getDocument(as: Exercise.self))
            } catch {
                throw ExerciseServiceError.dataFetchingError
            }
        }
        
        return(exercises)
    }
    
    // fetch all of the user's exercises from the backend
    func fetchExercises() async throws -> [Exercise] {
        guard let uid = Auth.auth().currentUser?.uid else { throw ExerciseServiceError.authenticationError }
        
        do {
            let snapshot = try await db.collection("exercises")
                .whereField("uid", isEqualTo: uid)
                .getDocuments()
            
            let exercises = snapshot.documents.compactMap({ try? $0.data(as: Exercise.self) })
            
            return exercises.sorted(by: { $0.name < $1.name })
            
        } catch {
            throw ExerciseServiceError.dataFetchingError
        }
    }
    
    // Delete an exercise from the backend
    func deleteExercise(id: String) async throws {
        do {
            try await db.collection("exercises").document(id)
                .delete()
        } catch {
            throw ExerciseServiceError.setDataError
        }
    }
}

extension ExerciseService {
    enum ExerciseServiceError: Error {
        case authenticationError
        case dataFetchingError
        case setDataError
    }
}
