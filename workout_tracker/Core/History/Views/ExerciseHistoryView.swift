//
//  ExerciseHistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct ExerciseHistoryView: View {
    let exercise: Exercise
    @ObservedObject var viewModel: ExerciseResultsViewModel
    
    init(_ exercise: Exercise) {
        self.exercise = exercise
        self.viewModel = ExerciseResultsViewModel(exercise)
    }
    
    var body: some View {
        VStack {
            if viewModel.exerciseInstances.isEmpty {
                Text("No data for \(exercise.name)")
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                            ExerciseResultRowView(exercise: self.exercise, instance: instance)
                        }
                    }
                }
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct ExerciseHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseHistoryView()
//    }
//}

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
            Divider()
            
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
            
            Divider()
        }
        .padding(.horizontal)
    }
}
