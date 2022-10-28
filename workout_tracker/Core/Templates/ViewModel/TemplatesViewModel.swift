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
    @Published var templateData = [TemplateData]()
    private let service = TemplateService()
    private let exerciseService = ExerciseService()
    
    // Allow the user to filter their templates by title or type
    var searchableTemplates: [TemplateData] {
        if searchText.isEmpty {
            return templateData
        } else {
            let lowercasedQuery = searchText.lowercased()

            return templateData.filter({
                $0.template.name.lowercased().contains(lowercasedQuery)
            })
        }
    }
    
    init() {
        fetchTemplates()
    }
    
    func fetchTemplates() {
        service.fetchTemplates { templates in
            self.fetchExercises(templates)
            
            self.loadingState = .data
        }
    }
    
    func fetchExercises(_ templateList: [Template]) {
        for template in templateList {
            exerciseService.fetchExercises(byExerciseIdList: template.exerciseList) { exercises in
                self.templateData.append(TemplateData(template, exercises))
            }
        }
    }
}

class TemplateData: Identifiable {
    let uuid = UUID()
    let template: Template
    let exercises: [Exercise]
    
    init(_ template: Template, _ exercises: [Exercise]) {
        self.template = template
        self.exercises = exercises
    }
}
