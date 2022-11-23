//
//  ModifyTemplateViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation
import SwiftUI

struct ModifyTemplateExerciseItem: Identifiable, Hashable {
    let id = UUID()
    var exerciseId: String
    var name: String
}

class ModifyTemplateViewModel: ObservableObject {
    private var template: Template?
    @Published var name: String
    @Published var exerciseList: [ModifyTemplateExerciseItem]
    @Published var didCreateTemplate = false
    
    let service = TemplateService()
    let exerciseService = ExerciseService()
    
    init(template: Template? = nil) {
        self.template = template
        self.exerciseList = [ModifyTemplateExerciseItem]()
        
        if template == nil {
            self.name = ""
            
        } else {
            self.name = template!.name
            for i in 0..<template!.exerciseIdList.count {
                self.exerciseList.append(ModifyTemplateExerciseItem(exerciseId: template!.exerciseIdList[i], name: template!.exerciseNameList[i]))
            }
        }
    }
    
    func addExercise(_ exerciseId: String) {
        exerciseService.fetchExerciseById(id: exerciseId) { exercise in
            self.exerciseList.append(ModifyTemplateExerciseItem(exerciseId: exercise.id!, name: exercise.name))
        }
    }
    
    func removeExercise(at offsets: IndexSet) {
        self.exerciseList.remove(atOffsets: offsets)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        self.exerciseList.move(fromOffsets: source, toOffset: destination)
    }
    
    // TODO: implement drag/drop to change template order
//    func moveExercise(from source: IndexSet, to destination: Int) {
//        self.exercises.move(fromOffsets: source, toOffset: destination)
//    }
    
    func modifyTemplate() {
        service.setTemplate(id: self.template?.id, name: self.name, exerciseIdList: exerciseList.map {$0.exerciseId}, exerciseNameList: exerciseList.map { $0.name }) { success in
            if success {
                // dismiss the screen
                self.didCreateTemplate = true
            } else {
                // show error message to user
            }
        }
    }
    
    // delete a template
    func deleteTemplate() {
        let id = self.template?.id ?? ""
        
        service.deleteTemplate(id: id) { success in
            if success {
                // nothing for now
            }
        }
    }
}
