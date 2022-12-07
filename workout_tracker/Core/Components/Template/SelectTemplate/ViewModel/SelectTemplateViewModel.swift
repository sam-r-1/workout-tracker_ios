//
//  SelectTemplateViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 11/14/22.
//

import Foundation

import Foundation

class SelectTemplateViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var userTemplates = [Template]()
    let service = TemplateService()
    
    init(forPreview: Bool = false) {
        if forPreview {
            self.userTemplates = MockService.sampleTemplates
        } else {
            fetchTemplates()
        }
    }
    
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
        private func fetchTemplates() {
            service.fetchTemplates { templates in
            self.userTemplates = templates
            }
        }
 }
