//
//  SelectTemplateViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/14/22.
//

import Foundation

extension SelectTemplateView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var loadingState = LoadingState.loading
        @Published var searchText = ""
        @Published var userTemplates = [Template]()
        @Published var selectedTemplate: Template? = nil
        let service = RealTemplateService()
        
        // Allow the user to filter their exercises by title or type
        var searchableTemplates: [Template] {
            if searchText.isEmpty {
                return userTemplates
            } else {
                let lowercasedQuery = searchText.lowercased()
                
                return userTemplates.filter({
                    $0.name.lowercased().contains(lowercasedQuery)
                })
            }
        }
        
        // Fetch the list of the user's exercises for selection
        func fetchTemplates() async {
            do {
                self.userTemplates = try await service.fetchTemplates()
                self.loadingState = .data
            } catch {
                debugPrint(error.localizedDescription)
                self.loadingState = .error
            }
        }
    }
}
