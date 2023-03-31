//
//  WorkoutDetailsScrollView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/4/22.
//

import SwiftUI

struct WorkoutDetailsScrollView: View {
    @ObservedObject var viewModel: HistoryView.ViewModel
    
    let workout: Workout
    
    init(workout: Workout, viewModel: HistoryView.ViewModel) {
        self.workout = workout
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if !viewModel.historyItems.isEmpty {
                List {
                    ForEach(viewModel.historyItems) { item in
                        InstanceHistoryRowView(exercise: item.exercise, instance: item.instance)
                    }
                    .onDelete { offset in
                        Task {
                            guard let idToDelete = viewModel.instances.first(where: { $0.id == viewModel.historyItems[offset.first!].instance.id })?.id else { return }
                            
                            viewModel.historyItems.remove(atOffsets: offset)
                            
                            await viewModel.deleteInstance(by: idToDelete)
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    
                    Text("No data for this workout.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.systemGray))
                    
                    Spacer()
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
