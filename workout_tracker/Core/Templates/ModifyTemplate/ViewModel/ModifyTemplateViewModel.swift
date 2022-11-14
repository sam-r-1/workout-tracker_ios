//
//  ModifyTemplateViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation
import SwiftUI

class ModifyTemplateViewModel: ObservableObject {
    private var template: Template?
    @Published var name: String
    @Published var exerciseIdList: [String]
    @Published var exerciseNameList: [String]
    @Published var didCreateTemplate = false
    
    let service = TemplateService()
    let exerciseService = ExerciseService()
    
    init(template: Template? = nil) {
        self.template = template
        
        if template == nil {
            self.name = ""
            self.exerciseIdList = [String]()
            self.exerciseNameList = [String]()
        } else {
            self.name = template!.name
            self.exerciseIdList = template!.exerciseIdList
            self.exerciseNameList = template!.exerciseNameList
        }
    }
    
    func addExercise(_ exerciseId: String) {
        exerciseService.fetchExerciseById(id: exerciseId) { exercise in
            self.exerciseIdList.append(exercise.id!)
            self.exerciseNameList.append(exercise.name)
        }
    }
    
    // TODO: implement drag/drop to change template order
//    func moveExercise(from source: IndexSet, to destination: Int) {
//        self.exercises.move(fromOffsets: source, toOffset: destination)
//    }
    
    func modifyTemplate() {
        service.setTemplate(id: self.template?.id, name: self.name, exerciseIdList: exerciseIdList, exerciseNameList: exerciseNameList) { success in
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
