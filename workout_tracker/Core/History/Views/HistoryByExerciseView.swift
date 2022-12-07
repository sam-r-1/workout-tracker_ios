//
//  HistoryByExerciseView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct HistoryByExerciseView: View {
    @StateObject var viewModel = ExerciseHistoryViewModel()
    
    var body: some View {
        switch viewModel.loadingState {
            case .data: dataView

            case .loading: LoadingView()
                
            case .error: Text("--") // placeholder for error message; should never be used currently
        }
    }
}

extension HistoryByExerciseView {
    // display when the user has workout data
    var dataView: some View {
        VStack {
            if viewModel.exercises.isEmpty {
                noDataView
            } else {
                List {
                    ForEach(viewModel.exercises) { exercise in
                        NavigationLink {
                            NavigationLazyView(ExerciseHistoryView(exercise: exercise))
                        } label: {
                            ExerciseRowView(exercise)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // Display when the user does not have any workouts
    var noDataView: some View {
        VStack {
            Spacer()
            
            Text("Data from completed workouts\n will appear here.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
        }
    }
}

struct HistoryByExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryByExerciseView(viewModel: ExerciseHistoryViewModel(forPreview: true))
    }
}
