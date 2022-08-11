//
//  PopUpMenuViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import SwiftUI

enum PopUpMenuViewModel: Int, CaseIterable {
    case fromTemplate
    case fromScratch
    
    
    var title: String {
        switch self {
        case .fromTemplate: return "Start from template"
        case .fromScratch: return "Start from scratch"
        }
    }
}
