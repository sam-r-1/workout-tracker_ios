//
//  WorkoutDetailsScrollView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/4/22.
//

import SwiftUI

struct WorkoutDetailsScrollView: View {
    @EnvironmentObject var viewModel: HistoryView.ViewModel
    
    let workout: Workout
    
    var body: some View {
        List {
            ForEach(viewModel.historyItems) { item in
                InstanceHistoryRowView(exercise: item.exercise, instance: item.instance)
            }
            .onDelete { offset in
                Task {
                    guard let idToDelete = viewModel.instances.first(where: { $0.id == viewModel.historyItems[offset.first!].instance.id })?.id else { return }
                    await viewModel.deleteInstance(by: idToDelete)
                }
            }
        }
        .onAppear {
            viewModel.createItems(forWorkout: workout)
        }
    }
}

//struct WorkoutDetailsScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailsScrollView()
//    }
//}
