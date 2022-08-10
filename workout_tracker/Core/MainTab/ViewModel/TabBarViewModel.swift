//
//  TabBarViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentItem: TabBarViewModel = .exercises
    
    var view: some View { return currentItem.view }
}

enum TabBarViewModel: Int, CaseIterable {
    case exercises
    case templates
    case history
    case visualize
    
    
    var title: String {
        switch self {
        case .exercises: return "Exercises"
        case .templates: return "Templates"
        case .history: return "History"
        case .visualize: return "Visualize"
        }
    }
    
    var imageName: String {
        switch self {
        case .exercises: return "house"
        case .templates: return "magnifyingglass"
        case .history: return "globe"
        case .visualize: return "bell"
        }
    }
    
    var view: some View {
        switch self {
        case .exercises: return Text("Exercises")
        case .templates: return Text("Templates")
        case .history: return Text("history")
        case .visualize: return Text("visualize")
        }
    }
}
