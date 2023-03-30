//
//  ExerciseResultsViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import Foundation

class ExerciseResultsViewModel: ObservableObject {
    @Published var exerciseInstances = [ExerciseInstance]()
    private let service = ExerciseInstanceService()
    
    init(fromPreview: Bool = false) {
        if fromPreview {
            exerciseInstances = MockService.sampleInstances
        }
    }
    
    var chronologicalInstances: [ExerciseInstance] {
        return exerciseInstances.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
    }
    
    func fetchInstancesForExercise(_ exerciseId: String?) async {
        guard exerciseId != nil else { return }
        do {
            self.exerciseInstances = try await service.fetchInstances(byExerciseId: exerciseId!)
        } catch _ {}
    }
    
    // delete an instance from both the local and backend
    func deleteInstance(at offsets: IndexSet) async {
        guard offsets.count == 1 else { return }
        
        do {
            try await service.deleteInstance(id: exerciseInstances[offsets.first!].id!)
            
            self.exerciseInstances.remove(atOffsets: offsets)
        } catch _ {}
    }
}
