//
//  SwiftUIView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct PreviousInstanceDataView: View {
    let exercise: Exercise
    let previousInstance: ExerciseInstance
    
    var body: some View {
        VStack(spacing: 8) {
            Text(CustomDateFormatter.dateFormatter.string(from: previousInstance.timestamp.dateValue()))
            
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

//struct PreviousInstanceDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviousInstanceDataView()
//    }
//}
