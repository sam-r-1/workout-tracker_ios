//
//  ModifyTemplateViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import Foundation
import SwiftUI

extension ModifyTemplateView {
    struct ModifyTemplateExerciseItem: Identifiable, Hashable {
        let id = UUID()
        var exerciseId: String
        var name: String
    }
    
    @MainActor
    class ViewModel: ObservableObject {
        private var template: Template?
        @Published var modifyingState = ModifyingState.editing
        @Published var name: String
        @Published var exerciseList: [ModifyTemplateExerciseItem]
        @Published var isEditingComplete = false
        
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
        
        func modifyTemplate() async {
            self.modifyingState = .loading
            
            do {
                try await service.setTemplate(id: self.template?.id, name: self.name, exerciseIdList: exerciseList.map {$0.exerciseId}, exerciseNameList: exerciseList.map { $0.name })
                
                self.isEditingComplete = true
                
            } catch {
                self.modifyingState = .error
            }
        }
        
        // delete a template
        func deleteTemplate() async {
            self.modifyingState = .loading
            
            let id = self.template?.id ?? ""
            
            do {
                try await service.deleteTemplate(id: id)
                
                self.isEditingComplete = true
            } catch {
                self.modifyingState = .error
            }
        }
    }
}
