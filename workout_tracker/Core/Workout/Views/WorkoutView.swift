//
//  WorkoutView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/16/22.
//

import SwiftUI

struct WorkoutView: View {
    @Binding var workoutActive: Bool
    @State private var showTimer = false
    @State private var showAddExercise = false
    @State private var topExpanded: Bool = true
    @ObservedObject var viewModel = WorkoutViewModel()
    
    init(workoutActive: Binding<Bool>, fromTemplate: Template? = nil) {
        self._workoutActive = workoutActive
        
        if fromTemplate != nil {
            viewModel.addExercisesFromTemplate(fromTemplate!)
        }
    }
    
    var body: some View {
        VStack {
            HeaderView("My Workout", includeDivider: true)
            
            ScrollView {
                LazyVStack {
                    ReorderableForEach(items: viewModel.items) { item in
                        ExerciseDisclosureGroupView(item: item) {
                            viewModel.deleteItem(at: viewModel.items.firstIndex(where: { $0.id == item.id })!)
                        }
                    } moveAction: { source, destination in
                        viewModel.moveItem(from: source, to: destination)
                    }
                    .padding(.horizontal, 8)

                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    showAddExercise.toggle()
                }, label: {
                    VStack(spacing: 4) {
                        Text("Add Exercise")
                        Image(systemName: "plus")
                    }
                })
                .font(.title3)
                .frame(width: 140, height: 50)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.finishWorkout()
                    }
                }, label: {
                    VStack(spacing: 4) {
                        Text("Finish Workout")
                        Image(systemName: "checkmark")
                    }
                })
                .font(.title3)
                .frame(width: 140, height: 50)
                .padding(8)
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
            }
            
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showAddExercise) {
            SelectExerciseView { exerciseId in
                viewModel.addItem(exerciseId)
            }
        }
        // dismiss view if workout created successfully
        .onReceive(viewModel.$didUploadWorkout) { success in
            if success {
                self.workoutActive = false
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workoutActive: Binding.constant(true))
    }
}
