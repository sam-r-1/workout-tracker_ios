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
