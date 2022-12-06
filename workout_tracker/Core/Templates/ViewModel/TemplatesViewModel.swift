//
//  TemplatesViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import Foundation

class TemplatesViewModel: ObservableObject {
    @Published var loadingState = LoadingState.loading
    @Published var searchText = ""
    @Published var templates = [Template]()
    private let service = TemplateService()
    private let exerciseService = ExerciseService()
    
    // Allow the user to filter their templates by title or type
    var searchableTemplates: [Template] {
        if searchText.isEmpty {
            return templates
        } else {
            let lowercasedQuery = searchText.lowercased()

            return templates.filter({
                $0.name.lowercased().contains(lowercasedQuery)
            })
        }
    }
    
    init(forPreview: Bool = false) {
        if forPreview {
            self.loadingState = .data
            self.templates = MockService.sampleTemplates
        } else {
            fetchTemplates()
        }
    }
    
    func fetchTemplates() {
        service.fetchTemplates { templates in
            self.templates = templates
            
            self.loadingState = .data
        }
    }
}
