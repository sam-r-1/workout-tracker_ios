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
    @State private var showErrorDialog = false
    
    @StateObject var viewModel = ViewModel()
    @StateObject private var expansionHandler = ExpansionHandler<ExerciseDataFields>()
    
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
                            ExerciseDisclosureGroupView(item: item, isExpanded: expansionHandler.isExpanded(item)) {
                                viewModel.deleteItem(at: viewModel.items.firstIndex(where: { $0.id == item.id })!)
                            }
                        } moveAction: { source, destination in
                            viewModel.moveItem(from: source, to: destination)
                        }
                    }
                }
            }
            
            if viewModel.workoutState == .submitting {
                LoadingView(includeBorder: true)
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
                .disabled(viewModel.workoutState == .submitting)
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
        .onReceive(viewModel.$workoutState) { state in
            if state == .finished {
                self.workoutActive = false
            } else if state == .error {
                self.showErrorDialog = true
            }
        }
        .alert(isPresented: $showErrorDialog) {
            Alert(
                title: Text("Something went wrong."),
                message: Text("There was an error uploading your workout. Please try again later.")
            )
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
