//
//  WorkoutDetailsView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/3/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteDialog = false
    let workout: Workout
    let onDelete: () -> Void
    
    init(_ workout: Workout, onDelete: @escaping () -> Void = {} ) {
        self.workout = workout
        self.onDelete = onDelete
    }
    
    var body: some View {

        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(CustomDateFormatter.dateFormatter.string(from: workout.timestamp.dateValue()))
                    .font(.largeTitle)
                    .bold()
                
                Spacer(minLength: 12)
                
                WorkoutDetailsScrollView(workout: workout)
                    .equatable()
            }
            .navigationTitle("Workout Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showDeleteDialog = true
                    } label: {
                        Text("Delete")
                    }
                    .foregroundColor(Color(.systemRed))
                    .alert("Delete data for this workout?", isPresented: $showDeleteDialog) {
                        Button("Delete", role: .destructive) {
                            onDelete()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        }
    }
}

//struct WorkoutDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailsView(MockService.sampleWorkouts[0])
//    }
//}
