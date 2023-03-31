//
//  HistoryByWorkoutView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/5/22.
//

import SwiftUI

struct HistoryByWorkoutView: View {
    @EnvironmentObject var viewModel: HistoryView.ViewModel
    
    var body: some View {
        Group {
            switch viewModel.loadingState {
                case .data: dataView
                    
                case .loading: LoadingView()
                    
                case .error: errorView
            }
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
                            WorkoutDetailsView(workout).environmentObject(viewModel)
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
    
    var errorView: some View {
        VStack {
            Spacer()
            
            Text("There was an error retrieving your history.\n Please try again later.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
        }
    }
}

struct HistoryByWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryByWorkoutView()
    }
}
