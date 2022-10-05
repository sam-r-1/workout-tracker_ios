//
//  HistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/29/22.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        VStack {
            
            HeaderView("Workout History")
            
            switch viewModel.loadingState {
                case .data: dataView

                case .loading: LoadingView()
                    
                case .error: Text("--") // placeholder for error message; should never be used currently
            }
        }
        .navigationBarHidden(true)
    }
}

extension HistoryView {
    
    // display when the user has workout data
    var dataView: some View {
        VStack {
            if viewModel.workouts.isEmpty {
                noDataView
            } else {
                ScrollView {
                    LazyVStack {
                       
                        ForEach(viewModel.workouts, id: \.timestamp) { workout in
                            NavigationLink {
                                NavigationLazyView(WorkoutDetailsView(workout, viewModel: viewModel))
                            } label: {
                                WorkoutRowView(workout: workout)
                            }
                        }
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
