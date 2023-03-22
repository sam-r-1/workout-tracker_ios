//
//  PopUpMenuViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

extension PopUpMenuView {
    
    @MainActor
    class ViewModel: ObservableObject {
        let exerciseService = ExerciseService()
        let templateService = TemplateService()
        
        // confirm that the user has at least one exercise created
        func canStartWorkout(_ option: PopUpMenuOption) async -> Bool {
            do {
                let exercises = try await exerciseService.fetchExercises()
                
                if !exercises.isEmpty && option == .fromTemplate {
//                    templateService.fetchTemplates { templates in
//                        return !templates.isEmpty
//                    }
                    debugPrint("Implement check for templates")
                    return false
                } else {
                    return true
                }
                
            } catch {
                debugPrint("Cannot verify if the user can start a workout.")
                return false
            }
        }
    }
    
}
