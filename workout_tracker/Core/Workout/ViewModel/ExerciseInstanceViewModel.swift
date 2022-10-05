//
//  ExerciseInstanceViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/30/22.
//

import Foundation
import Firebase

class ExerciseInstanceViewModel: ObservableObject {
    @Published var prevWeight: Double?
    @Published var prevReps: Int?
    @Published var prevTime: Double?
    @Published var prevDate: Date?
    
    @Published var showPrev: Bool = false
    
    private let service = ExerciseInstanceService()
    
    init(_ exerciseId: String) {
        fetchPreviousInstanceById(exerciseId)
    }
    
    private func fetchPreviousInstanceById(_ exerciseId: String) {
        service.fetchPreviousInstanceDataById(exerciseId) { instance in
            self.prevWeight = instance.weight
            self.prevReps = instance.reps
            self.prevTime = instance.time
            
            self.prevDate = instance.timestamp.dateValue()
            
            self.showPrev = true
        }
    }
}