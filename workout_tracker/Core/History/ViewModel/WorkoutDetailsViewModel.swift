//
//  WorkoutDetailsViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import Foundation

@MainActor
class WorkoutDetailsViewModel: ObservableObject {
    @Published var items = [WorkoutHistoryItem]()
    private let service = ExerciseInstanceService()
    
    nonisolated func update() {
        self.objectWillChange.send()
    }
    
    func fetchItems(fromInstanceIdList instanceIdList: [String]) async {
        do {
            let instances = try await service.fetchInstances(byInstanceIdList: instanceIdList)
            
            for instance in instances {
                self.items.append(WorkoutHistoryItem(fromInstance: instance, parent: self))
            }
        } catch _ {}
    }
    
    func deleteInstance(by id: String) {
        service.deleteInstances(fromInstanceIdList: [id]) // delete from Firebase
        
        self.items.remove(at: self.items.firstIndex(where: { $0.instance.id == id })!) // delete from local
    }
}
