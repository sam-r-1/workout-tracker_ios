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
    
    // Formatters
    @State private var doubleFormatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter
    }()
    
    @State private var timeFormatter: DateComponentsFormatter = {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.zeroFormattingBehavior = .dropLeading
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.allowsFractionalUnits = true
        timeFormatter.unitsStyle = .abbreviated
        return timeFormatter
    }()
    
    @State private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(dateFormatter.string(from: instance.timestamp.dateValue()))
                        .bold()
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if exercise.includeWeight {
                            HStack {
                                Text("Weight: ")
                                Text("\(doubleFormatter.string(from: instance.weight as NSNumber) ?? "0")lbs")
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
                                Text(timeFormatter.string(from: instance.time) ?? "Error loading")
                            }
                        }
                    }
                    .font(.title3)
                    .padding(.leading)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct ExerciseResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseResultRowView(exercise: MockService.sampleExercises[2], instance: MockService.sampleInstances[0])
    }
}
