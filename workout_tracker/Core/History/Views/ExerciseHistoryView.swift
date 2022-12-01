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
    @StateObject var viewModel = ExerciseResultsViewModel()
    
    var body: some View {
        VStack {
            if viewModel.exerciseInstances.isEmpty {
                Text("No data for \(exercise.name)")
            } else {
                VStack {
                    PerformanceChartTileView(title: "Weight", entries: viewModel.chronologicalInstances.map { ChartDataEntry(x: $0.timestamp.dateValue().timeIntervalSinceReferenceDate.magnitude, y: $0.weight) })
                        .frame(height: 300)
                                        
                    Divider()
                    
//                    ScrollView {
//                        LazyVStack(spacing: 0) {
//                            ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
//                                ExerciseResultRowView(exercise: self.exercise, instance: instance) { id in
//                                    viewModel.deleteInstance(by: id)
//                                }
//                            }
//                        }
//                    }
                    List {
                        ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                            ExerciseResultRowView(exercise: self.exercise, instance: instance)
                        }
                        .onDelete(perform: viewModel.deleteInstance)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear {
            viewModel.fetchInstancesFromIdList(self.exercise.id)
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseHistoryView_Previews: PreviewProvider {
    static let previewExercise = MockService.sampleExercises[2]

    static var previews: some View {
        NavigationView {
            ExerciseHistoryView(exercise: previewExercise, viewModel: ExerciseResultsViewModel(fromPreview: true))
        }
    }
}
