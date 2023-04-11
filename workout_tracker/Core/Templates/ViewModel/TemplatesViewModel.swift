//
//  TemplatesViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/11/22.
//

import Foundation

extension TemplatesView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var loadingState = LoadingState.loading
        @Published var searchText = ""
        @Published var templates = [Template]()
        private let service = TemplateService()
        private let exerciseService = RealExerciseService()
        
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
        
        func fetchTemplates() async {
            do {
                self.templates = try await service.fetchTemplates()
                self.loadingState = .data
            } catch {
                debugPrint(error.localizedDescription)
                self.loadingState = .error
            }
        }
    }
}
