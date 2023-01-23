//
//  WorkoutView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var workoutActive: Bool
    @State private var showTimer = false
    @State private var showAddExercise = false
    @State private var showFinishWorkoutDialog = false
    @StateObject var viewModel = WorkoutViewModel()
    let template: Template?
    
    init(workoutActive: Binding<Bool>, fromTemplate: Template? = nil) {
        self._workoutActive = workoutActive
        self.template = fromTemplate
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    LazyVStack {
                        ReorderableForEach(items: viewModel.items) { item in
                            ExerciseDisclosureGroupView(item: item) {
                                viewModel.deleteItem(at: viewModel.items.firstIndex(where: { $0.id == item.id })!)
                            }
                        } moveAction: { source, destination in
                            viewModel.moveItem(from: source, to: destination)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("My Workout")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showAddExercise.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
                
                Button {
                    showFinishWorkoutDialog.toggle()
                } label: {
                    Image(systemName: "checkmark.circle")
                }
                .foregroundColor(Color(.systemGreen))

            }
        }
        .fullScreenCover(isPresented: $showAddExercise) {
            SelectExerciseView { exerciseId in
                viewModel.addItem(exerciseId)
            }
        }
        .task {
            if template != nil {
                await viewModel.addExercisesFromTemplate(self.template!)
            }
        }
        // dismiss view if workout created successfully
        .onReceive(viewModel.$didUploadWorkout) { success in
            if success {
                self.workoutActive = false
            }
        }
        .alert("Finish Workout?", isPresented: $showFinishWorkoutDialog) {
            Button("No", role: .cancel) {}
            
            Button("Finish") {
                Task {
                    await viewModel.finishWorkout()
                }
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutView(workoutActive: Binding.constant(true))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
