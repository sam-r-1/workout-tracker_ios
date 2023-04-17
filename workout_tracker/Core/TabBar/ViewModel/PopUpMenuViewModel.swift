//
//  PopUpMenuViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import Foundation

extension PopUpMenuView {
    
    @MainActor
    class ViewModel: ObservableObject {
        let exerciseService = RealExerciseService()
        let templateService = RealTemplateService()
        
        // confirm that the user has at least one exercise created
        func canStartWorkout(_ option: PopUpMenuOption) async -> Bool {
            do {
                let exercises = try await exerciseService.fetchExercises()
                
                if exercises.isEmpty { return false }
                
                if option == .fromTemplate {
                    let templates = try await templateService.fetchTemplates()
                    
                    return !templates.isEmpty
                }
                
                return true
                
            } catch {
                debugPrint("Cannot verify if the user can start a workout.")
                return false
            }
        }
    }
    
}
