//
//  WorkoutDetailsScrollView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/4/22.
//

import SwiftUI

struct WorkoutDetailsScrollView: View, Equatable {
    static func == (lhs: WorkoutDetailsScrollView, rhs: WorkoutDetailsScrollView) -> Bool {
        return lhs.workout.timestamp == rhs.workout.timestamp
    }
    
    let workout: Workout
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    
    init(_ workout: Workout) {
        self.workout = workout
        self.viewModel = WorkoutDetailsViewModel(workout)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.exerciseInstances, id: \.timestamp) { instance in
                    InstanceHistoryRowView(instance, onDelete: { id in
                        viewModel.deleteInstance(by: id)
                    })
                        .padding(.horizontal, 14)
                        .padding(.vertical, 4)
                }
            }
            
            Spacer()
        }
    }
}

//struct WorkoutDetailsScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailsScrollView()
//    }
//}
