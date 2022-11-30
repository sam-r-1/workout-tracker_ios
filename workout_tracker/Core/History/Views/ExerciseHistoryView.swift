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
            // TODO: uncomment when finished testing charts
//            if viewModel.exerciseInstances.isEmpty {
//                Text("No data for \(exercise.name)")
//            } else {
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
//                            ExerciseResultRowView(exercise: self.exercise, instance: instance) { id in
//                                viewModel.deleteInstance(by: id)
//                            }
//                        }
//                    }
//                }
//            }
            PerformanceLineChartView(entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSince1970.magnitude, y: $0.weight) })
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Print Dates") {
                for instance in viewModel.chronologicalInstances {
                    print(instance.timestamp.dateValue().timeIntervalSince1970.magnitude)
                }
            }
        }
    }
}

//struct ExerciseHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseHistoryView()
//    }
//}
