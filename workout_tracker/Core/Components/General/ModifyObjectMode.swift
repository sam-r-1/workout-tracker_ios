//
//  ModifyObjectMode.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/8/22.
//

import Foundation

import Foundation

enum ModifyObjectMode {
    case add, edit
    
    var submitText: String {
        switch self {
        case .add: return "Add"
        case .edit: return "Save"
        }
    }
}
