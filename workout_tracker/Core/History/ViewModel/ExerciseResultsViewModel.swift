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
    
    func fetchInstancesFromIdList(_ exerciseId: String?) {
        guard exerciseId != nil else { return }
        service.fetchInstances(byExerciseId: exerciseId!) { instances in
            self.exerciseInstances = instances
        }
    }
    
    // delete an instance from both the local and backend
    func deleteInstance(at offsets: IndexSet) {
        guard offsets.count == 1 else { return }
        
        service.deleteInstances(fromInstanceIdList: [exerciseInstances[offsets.first!].id!])
        self.exerciseInstances.remove(atOffsets: offsets)
    }
}
