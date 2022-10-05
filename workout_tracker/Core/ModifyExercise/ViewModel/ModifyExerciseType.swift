//
//  ModifyExerciseType.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/4/22.
//

import Foundation

enum ModifyExerciseType {
    case add, edit
    
    var submitText: String {
        switch self {
        case .add: return "Add"
        case .edit: return "Save"
        }
    }
}
