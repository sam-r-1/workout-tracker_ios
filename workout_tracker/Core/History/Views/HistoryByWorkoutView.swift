//
//  HistoryByWorkoutView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct HistoryByWorkoutView: View {
    @StateObject var viewModel = WorkoutHistoryViewModel()
    
    var body: some View {
        switch viewModel.loadingState {
            case .data: dataView

            case .loading: LoadingView()
                
            case .error: Text("--") // placeholder for error message; should never be used currently
        }
    }
}

extension HistoryByWorkoutView {
    // display when the user has workout data
    var dataView: some View {
        VStack {
            if viewModel.workouts.isEmpty {
                noDataView
            } else {
                List {
                    ForEach(viewModel.workouts, id: \.timestamp) { workout in
                        NavigationLink {
                            NavigationLazyView(WorkoutDetailsView(workout, onDelete: {
                                viewModel.deleteWorkout(workout: workout)
                            }))
                        } label: {
                            WorkoutRowView(workout: workout)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                    }
                }
            }
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

struct HistoryByWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryByWorkoutView(viewModel: WorkoutHistoryViewModel(forPreview: true))
    }
}
