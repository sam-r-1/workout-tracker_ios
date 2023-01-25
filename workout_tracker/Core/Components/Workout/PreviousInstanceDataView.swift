//
//  SwiftUIView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI
import Firebase

struct PreviousInstanceDataView: View {
    let exercise: Exercise
    let previousInstance: ExerciseInstance
    
    var body: some View {
        VStack(spacing: 10) {
            Text(CustomDateFormatter.mediumDateFormatter.string(from: previousInstance.timestamp.dateValue()))
            
            if exercise.includeWeight {
                Text(WeightFormatter.weight.string(from: previousInstance.weight as NSNumber) ?? "0.0")
                    .font(.title3)
            }
            
            if exercise.includeReps {
                Text("\(previousInstance.reps)")
                    .font(.title3)
            }
            
            if exercise.includeTime {
                Text(TimeFormatter.durationResult.string(from: previousInstance.time) ?? "0s")
                    .font(.title3)
            }
        }
        .foregroundColor(Color(.systemGray))
    }
}

struct PreviousInstanceDataView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousInstanceDataView(exercise: Exercise(uid: "", name: "Leg Press", type: "", details: "", includeWeight: true, includeReps: true, includeTime: true), previousInstance: ExerciseInstance(uid: "", exerciseId: "", timestamp: Timestamp(), reps: 5, time: 90, weight: 250))
    }
}
