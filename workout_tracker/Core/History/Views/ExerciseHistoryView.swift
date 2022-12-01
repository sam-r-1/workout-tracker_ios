//
//  ExerciseHistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI
import Charts
// import Firebase

struct ExerciseHistoryView: View {
    let exercise: Exercise
    @ObservedObject var viewModel: ExerciseResultsViewModel
    
    init(_ exercise: Exercise) {
        self.exercise = exercise
        self.viewModel = ExerciseResultsViewModel(exercise)
    }
    
    var body: some View {
        Group {
            if viewModel.exerciseInstances.isEmpty {
                Text("No data for \(exercise.name)")
            } else {
                VStack {
                    PerformanceLineChartView(entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.weight) })
                        .frame(height: 300)
                    
                    Divider()
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                                ExerciseResultRowView(exercise: self.exercise, instance: instance) { id in
                                    viewModel.deleteInstance(by: id)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Print Dates") {
                for instance in viewModel.chronologicalInstances {
                    print(instance.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude)
                }
            }
        }
    }
}

//struct ExerciseHistoryView_Previews: PreviewProvider {
//    static var previewInstances: [ExerciseInstance] {
//        let range = 1...15
//        return range.map({ ExerciseInstance(uid: "previewUser", exerciseId: "previewExercise", timestamp: Timestamp(date: Date(timeIntervalSinceReferenceDate: Double($0) * 86401.0)), reps: 5, time: 100, weight: Double.random(in: (2 * Double($0) + 80)..<(2 * Double($0) + 120))) })
//    }
//
//    static var previews: some View {
//        ExerciseHistoryView()
//    }
//}
