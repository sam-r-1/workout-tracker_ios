//
//  TabBarViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentItem: TabBarViewModel = .exercises
    
    var view: some View { return currentItem.view }
}

enum TabBarViewModel: Int, CaseIterable {
    case exercises, templates, history, settings
    
    var title: String {
        switch self {
        case .exercises: return "Exercises"
        case .templates: return "Templates"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }
    
    var imageName: String {
        switch self {
        case .exercises: return "bell"
        case .templates: return "globe"
        case .history: return "time"
        case .settings: return "gear"
        }
    }
    
    var view: some View {
        switch self {
        case .exercises: return AnyView(ExercisesView())
        case .templates: return AnyView(TemplatesView())
        case .history: return AnyView(Text("History"))
        case .settings: return AnyView(Text("Settings"))
        }
    }
}
