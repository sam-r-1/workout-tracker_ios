//
//  WorkoutDetailsView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    let workout: Workout
    @State private var showDeleteDialog = false
    @ObservedObject var viewModel: WorkoutHistoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(_ workout: Workout, viewModel: WorkoutHistoryViewModel) {
        self.workout = workout
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            Text("Workout Data")
                .font(.largeTitle)
                .bold()
            
            Spacer(minLength: 12)
            
            WorkoutDetailsScrollView(workout)
                .equatable()
        }
        .navigationTitle(CustomDateFormatter.dateFormatter.string(from: workout.timestamp.dateValue()))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            // delete button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showDeleteDialog = true
                } label: {
                    Text("Delete")
                }
                .foregroundColor(Color(.systemRed))
                .alert("Delete data for this workout?", isPresented: $showDeleteDialog) {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteWorkout(workout: workout)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailsView(workout: Workout(uid: "", timestamp: Timestamp(), exerciseInstanceIdList: ["id1", "id2", "id3"]))
    }
}
