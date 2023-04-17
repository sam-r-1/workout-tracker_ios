//
//  TemplateService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation
import Firebase

protocol TemplateService {
    
    func setTemplate(id: String?, name: String, exerciseIdList: [String], exerciseNameList: [String]) async throws
    
    func fetchTemplates() async throws -> [Template]
    
    func deleteTemplate(id: String) async throws
    
    func deleteExerciseRef(id: String, name: String) async throws
    
}

struct RealTemplateService: TemplateService {
    private let db = Firestore.firestore()
    
    // create/edit a template and post it to the database
    func setTemplate(id: String? = nil, name: String, exerciseIdList: [String], exerciseNameList: [String]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw TemplateServiceError.authenticationError }
        
        let data = ["uid": uid,
                    "name": name,
                    "timestamp": Timestamp(),
                    "exerciseIdList": exerciseIdList,
                    "exerciseNameList": exerciseNameList] as [String: Any]
        
        let collectionRef = db.collection("templates")
        
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
            throw TemplateServiceError.setDataError
        }
    }
    
    // fetch all of the user's templates from the backend
    func fetchTemplates() async throws -> [Template] {
        guard let uid = Auth.auth().currentUser?.uid else { throw TemplateServiceError.authenticationError }
        
        do {
            let snapshot = try await db.collection("templates")
                .whereField("uid", isEqualTo: uid)
                .getDocuments()
            
            let templates = snapshot.documents.compactMap({ try? $0.data(as: Template.self) })
            
            return templates.sorted(by: { $0.name < $1.name })
            
        } catch {
            throw TemplateServiceError.dataFetchingError
        }
    }
    
    // Delete a template from the backend
    func deleteTemplate(id: String) async throws {
        do {
            try await db.collection("templates").document(id)
                .delete()
        } catch {
            throw TemplateServiceError.setDataError
        }
    }
    
    // Remove exercise id's from the template's exerciseList property. Use after the exercises themselves are deleted
    func deleteExerciseRef(id: String, name: String) async throws {
        let query = db.collection("templates")
            .whereField("exerciseIdList", arrayContains: id)
        
        do {
            let snapshot = try await query.getDocuments()
            
            for doc in snapshot.documents {
                try await doc.reference.updateData(["exerciseIdList": FieldValue.arrayRemove([id])])
                
                try await doc.reference.updateData(["exerciseNameList": FieldValue.arrayRemove([name])])
            }
        } catch {
            throw TemplateServiceError.removeExerciseReferenceError
        }
    }
}

extension RealTemplateService {
    enum TemplateServiceError: Error {
        case authenticationError
        case dataFetchingError
        case setDataError
        case removeExerciseReferenceError
    }
}

// MARK: - Stub
struct StubTemplateService: TemplateService {
    func setTemplate(id: String?, name: String, exerciseIdList: [String], exerciseNameList: [String]) async throws {
        return
    }
    
    func fetchTemplates() async throws -> [Template] {
        return MockService.sampleTemplates
    }
    
    func deleteTemplate(id: String) async throws {
        return
    }
    
    func deleteExerciseRef(id: String, name: String) async throws {
        return
    }
    
}
