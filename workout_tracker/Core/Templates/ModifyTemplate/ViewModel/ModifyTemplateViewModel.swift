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
    @Published var exercises = [Exercise]()
    @Published var didCreateTemplate = false
    
    let service = TemplateService()
    let exerciseService = ExerciseService()
    
    init(template: Template? = nil) {
        self.template = template
        
        if template == nil {
            self.name = ""
        } else {
            self.name = template!.name
        }
    }
    
    func addExercise(_ exerciseId: String) {
        exerciseService.fetchExerciseById(id: exerciseId) { exercise in
            self.exercises.append(exercise)
        }
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        self.exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func modifyTemplate() {
        service.setTemplate(id: self.template?.id, name: self.name, exerciseIdList: exercises.map { $0.id! }, exerciseNameList: exercises.map { $0.name }) { success in
            if success {
                // dismiss the screen
                self.didCreateTemplate = true
            } else {
                // show error message to user
            }
        }
    }
    
//    func fetchExercisesForTemplate() {
//        exerciseService.fetchExercises(byExerciseIdList: self.template?.template.exerciseList ?? []) { exercises in
//            self.exercises = exercises
//        }
//    }
    
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
