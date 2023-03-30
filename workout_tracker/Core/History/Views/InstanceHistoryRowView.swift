//
//  InstanceHistoryRowView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct InstanceHistoryRowView: View {
    @Environment(\.sizeCategory) var sizeCategory
    let exercise: Exercise?
    let instance: ExerciseInstance
    let onDelete: (String) async -> Void
    let iconSize = 20.0
    let accessibilityThreshold = ContentSizeCategory.accessibilityLarge
    
    var body: some View {
        Group {
            if exercise != nil {
                Group {
                    Text(exercise!.name)
                        .bold()
                        .font(.title2)
                    
                    if sizeCategory <= accessibilityThreshold {
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if exercise!.includeWeight {
                            HStack {
                                WeightIcon()
                                    .frame(width: iconSize, height: iconSize)
                                    .foregroundColor(Color(.systemGray))
                                
                                Text("\(WeightFormatter.weight.string(from: instance.weight as NSNumber) ?? "0") lbs")
                            }
                        }
                        
                        if exercise!.includeReps {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .frame(width: iconSize, height: iconSize)
                                    .foregroundColor(Color(.systemGray))
                                
                                Text("\(instance.reps)")
                            }
                        }
                        
                        if exercise!.includeTime {
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
                    .padding(.leading, 10)

                }
                .embedInStack(verticalIfLargerThan: accessibilityThreshold)
                .padding(8)
                
            } else {
                LoadingIndicator(animation: .circleBars, speed: .fast)
            }
        }
    }
}

struct InstanceHistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceHistoryRowView(exercise: MockService.sampleExercises[0], instance: MockService.sampleInstances[1]) { _ in
            //
        }
    }
}
