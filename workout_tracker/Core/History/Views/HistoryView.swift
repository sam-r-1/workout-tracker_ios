//
//  HistoryView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 9/29/22.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HeaderView("Workout History")
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.workouts, id: \.timestamp) { workout in
                        NavigationLink {
                            NavigationLazyView(WorkoutDetailsView(workout))
                        } label: {
                            WorkoutRowView(workout: workout)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
