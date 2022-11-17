//
//  TemplateService.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation
import Firebase

struct TemplateService {
    
    // create/edit a template and post it to the database
    func setTemplate(id: String? = nil, name: String, exerciseIdList: [String], exerciseNameList: [String], completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "name": name,
                    "timestamp": Timestamp(),
                    "exerciseIdList": exerciseIdList,
                    "exerciseNameList": exerciseNameList] as [String: Any]
        
        let collectionRef = Firestore.firestore().collection("templates")
        
        // if an id is provided, set the ref to that location, otherwise give a blank one
        let ref: DocumentReference
        if id != nil {
            ref = collectionRef.document(id!)
        } else {
            ref = collectionRef.document()
        }
        
        ref.setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload template with error \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
    
    // fetch all of the user's templates from the backend
    func fetchTemplates(completion: @escaping([Template]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("templates")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                var templates = documents.compactMap({ try? $0.data(as: Template.self) })

                // add the id's
                if templates.count >= 1 {
                    for i in 0..<templates.count {
                        templates[i].id = documents[i].documentID
                    }
                }
                
                completion(templates.sorted(by: { $0.name < $1.name }))
            }
    }
    
    // Delete a template from the backend
    func deleteTemplate(id: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("templates").document(id)
            .delete { error in
                guard error == nil else {
                    print("DEBUG: \(error!.localizedDescription)")
                    return
                }
                
                completion(true)
            }
    }
    
    // Remove exercise id's from the template's exerciseList property. Use after the exercises themselves are deleted
    func deleteExerciseRef(_ id: String) {
        let query = Firestore.firestore().collection("templates")
            .whereField("exerciseIdList", arrayContains: id)
        
        query.getDocuments { snapshot, error in
            guard error == nil else {
                print("DEBUG: \(error!.localizedDescription)")
                return
            }
            
            let documents = snapshot!.documents
            
            documents.forEach { doc in
                doc.reference.updateData(["exerciseIdList": FieldValue.arrayRemove([id])]) { error in
                    guard error == nil else {
                        print("DEBUG: \(error!.localizedDescription)")
                        return
                    }
                }
            }
        }
    }
}
