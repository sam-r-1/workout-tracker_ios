//
//  PopUpMenuViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

class PopUpMenuViewModel: ObservableObject {
    let exerciseService = ExerciseService()
    let templateService = TemplateService()
    
    func canStartWorkout(_ option: PopUpMenuOption, completion: @escaping(Bool) -> Void) {
        // confirm that the user has at least one exercise created
        exerciseService.fetchExercises { exercises in
            if exercises.isEmpty {
                completion(false)
            } else if option == .fromTemplate {
                self.templateService.fetchTemplates { templates in
                    completion(!templates.isEmpty)
                }
            } else {
                completion(true)
            }
        }
    }
}
