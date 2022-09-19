//
//  WorkoutView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import SwiftUI

struct WorkoutView: View {
    @State private var showTimer = false
    @State private var showAddExercise = false
    @State private var topExpanded: Bool = true
    @State private var reps = ""
    @ObservedObject var viewModel = WorkoutViewModel()
    @ObservedObject var exercisesViewModel = ExerciseInstancesViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach($exercisesViewModel.exerciseInstances, id: \.timestamp) { $instance in
                        ExerciseDisclosureGroupView(viewModel: viewModel)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            
            Button("Add Exercise") {
                showAddExercise.toggle()
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showAddExercise) {
            SelectExerciseView(viewModel: exercisesViewModel)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}

extension WorkoutView {
    
}
