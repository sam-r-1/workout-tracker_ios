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
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var viewModel: HistoryView.ViewModel
    
    @State private var showDeleteDialog = false
    
    let workout: Workout
    
    let accessibilityThreshold = ContentSizeCategory.accessibilityLarge
    
    init(_ workout: Workout) {
        self.workout = workout
    }
    
    var body: some View {

        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack {
                Group {
                    sizeCategory > accessibilityThreshold
                        ? Text(CustomDateFormatter.shortDateFormatter.string(from: workout.timestamp.dateValue()))
                            .bold()
                        : Text(CustomDateFormatter.mediumDateFormatter.string(from: workout.timestamp.dateValue()))
                            .bold()
                }
                .font(.largeTitle)
                
                Spacer(minLength: 12)
                
                WorkoutDetailsScrollView(workout: workout)
            }
            .navigationTitle("Workout Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showDeleteDialog = true
                    } label: {
                        Image(systemName: "trash.circle")
                    }
                    .foregroundColor(Color(.systemRed))
                    .alert("Delete data for this workout?", isPresented: $showDeleteDialog) {
                        Button("Delete", role: .destructive) {
                            Task {
                                await viewModel.deleteWorkout(workout: workout)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
            
            if viewModel.loadingState == .loading {
                LoadingView(includeBorder: true)
            }
        }
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailsView(MockService.sampleWorkouts[0])
    }
}
