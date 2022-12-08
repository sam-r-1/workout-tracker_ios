//
//  WorkoutDetailsScrollView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/4/22.
//

import SwiftUI

struct WorkoutDetailsScrollView: View {
    
    let workout: Workout
    @StateObject var viewModel = WorkoutDetailsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                InstanceHistoryRowView(exercise: item.exercise, instance: item.instance, onDelete: { id in
                    viewModel.deleteInstance(by: id)
                })
            }
        }
        .task {
            await viewModel.fetchItems(fromInstanceIdList: workout.exerciseInstanceIdList)
        }
    }
}

//struct WorkoutDetailsScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailsScrollView()
//    }
//}
