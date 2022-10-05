//
//  PopUpMenuViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

class PopUpMenuViewModel: ObservableObject {
    let service = ExerciseService()
    
    func userHasExercises(_ option: PopUpMenuOption, completion: @escaping(Bool) -> Void) {
        // if starting a workout from scratch, confirm that the user has at least one exercise created
        if option == .fromScratch {
            service.fetchExercises { exercises in
                completion(!exercises.isEmpty)
            }
        } else { completion(false) }
    }
}

enum PopUpMenuOption: Int, CaseIterable {
    // case fromTemplate
    case fromScratch
    
    
    var title: String {
        switch self {
            // case .fromTemplate: return "Start from template"
            case .fromScratch: return "Start a workout"
        }
    }
    
    var workoutView: some View {
        switch self {
            case.fromScratch: return WorkoutView()
        }
    }
}
