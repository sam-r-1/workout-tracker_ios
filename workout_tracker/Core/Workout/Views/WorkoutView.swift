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
    @State private var topExpanded: Bool = true
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
                HeaderView("My Workout", subtitle: CustomDateFormatter.dateFormatter.string(from: Date.now))
                
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
                    
                    HStack{}.frame(height: 50)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showAddExercise.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add")
                            }
                        })
                        .padding(8)
                        .foregroundColor(Color.white)
                        .background(Color(.systemBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button(action: {
                            Task {
                                await viewModel.finishWorkout()
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "flag.2.crossed")
                                Text("Finish")
                            }
                        })
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color(.systemGreen))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .navigationBarHidden(true)
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
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkoutView(workoutActive: Binding.constant(true))
            WorkoutView(workoutActive: Binding.constant(true))
                .environment(\.sizeCategory, .accessibilityExtraLarge)
        }
    }
}
