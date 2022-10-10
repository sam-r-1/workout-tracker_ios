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
    
    // Prevent the text on the tab bar from scaling too high due to Dynamic Type
    public func tabBarTextSize() -> CGFloat {
        return fmin(UIFont.preferredFont(forTextStyle: .caption1).pointSize, 12.0)
    }
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
    
    var image: Image {
        switch self {
        case .exercises: return Image("dumbell")
        case .templates: return Image("checklist")
        case .history: return Image(systemName: "clock")
        case .settings: return Image(systemName: "gear")
        }
    }
    
    var view: some View {
        switch self {
        case .exercises: return AnyView(ExercisesView())
        case .templates: return AnyView(TemplatesView())
        case .history: return AnyView(HistoryView())
        case .settings: return AnyView(SettingsView())
        }
    }
}
