//
//  ExerciseResultRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/6/22.
//

import SwiftUI

struct ExerciseResultRowView: View {
    let exercise: Exercise
    let instance: ExerciseInstance
    
    var body: some View {
        HStack {
            DateIcon(date: instance.timestamp.dateValue())
                .frame(width: 65)
            VStack(alignment: .leading, spacing: 5) {
                if exercise.includeWeight {
                    HStack {
                        Text("Weight: ")
                        Text("\(WeightFormatter.weight.string(from: instance.weight as NSNumber) ?? "0")lbs")
                    }
                }
                
                if exercise.includeReps {
                    HStack {
                        Text("Reps:     ")
                        Text("\(instance.reps)")
                    }
                }
                
                if exercise.includeTime {
                    HStack {
                        Text("Time:     ")
                        Text(TimeFormatter.durationResult.string(from: instance.time) ?? "Error loading")
                    }
                }
            }
            .font(.title3)
            .padding(.leading)
            
            Spacer()
        }
        .padding(8)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        // .background(Color(.systemGray5))
    }
}

struct ExerciseResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseResultRowView(exercise: MockService.sampleExercises[2], instance: MockService.sampleInstances[0])
    }
}
