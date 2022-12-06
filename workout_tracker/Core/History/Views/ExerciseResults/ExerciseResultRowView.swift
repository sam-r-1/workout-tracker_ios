//
//  ExerciseResultRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/6/22.
//

import SwiftUI

struct ExerciseResultRowView: View {
    @Environment(\.colorScheme) var colorScheme
    let exercise: Exercise
    let instance: ExerciseInstance
    let iconSize = 20.0
    
    var body: some View {
        HStack {
            DateIcon(date: instance.timestamp.dateValue())
                .frame(width: 55)
            VStack(alignment: .leading, spacing: 5) {
                if exercise.includeWeight {
                    HStack {
                        WeightIcon()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(Color(.systemGray))
                        
                        Text("\(WeightFormatter.weight.string(from: instance.weight as NSNumber) ?? "0") lbs")
                    }
                }
                
                if exercise.includeReps {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(Color(.systemGray))
                        
                        Text("\(instance.reps)")
                    }
                }
                
                if exercise.includeTime {
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(Color(.systemGray))
                        
                        Text(TimeFormatter.durationResult.string(from: instance.time) ?? "Error loading")
                    }
                }
            }
            .font(.body)
            .padding(.leading)
            
            Spacer()
        }
        .padding(8)
    }
}

struct ExerciseResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseResultRowView(exercise: MockService.sampleExercises[2], instance: MockService.sampleInstances[0])
    }
}
