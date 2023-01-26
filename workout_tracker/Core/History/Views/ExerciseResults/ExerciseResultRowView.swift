//
//  ExerciseResultRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/6/22.
//

import SwiftUI

struct ExerciseResultRowView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    let exercise: Exercise
    let instance: ExerciseInstance
    @ScaledMetric(relativeTo: .title3) var iconSize: CGFloat = 20.0
    let accessibilityThreshold = ContentSizeCategory.accessibilityLarge
    
    var body: some View {
        HStack {
            Group {
                
                if sizeCategory > accessibilityThreshold {
                    Text(CustomDateFormatter.shortDateFormatter.string(from: instance.timestamp.dateValue()))
                        .font(.body)
                        .bold()
                } else {
                    DateIcon(date: instance.timestamp.dateValue())
                        .frame(width: 55)
                }
                
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
            }
            .embedInStack(verticalIfLargerThan: accessibilityThreshold)
            
            Spacer()
        }
        .padding(8)
    }
}

struct ExerciseResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ExerciseResultRowView(exercise: MockService.sampleExercises[2], instance: MockService.sampleInstances[0])
        }
    }
}
