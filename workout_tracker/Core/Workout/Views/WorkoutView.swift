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
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = WorkoutViewModel()
    
    var body: some View {
        VStack {
            HeaderView("My Workout", includeDivider: true)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.items) {item in
                        ExerciseDisclosureGroupView(item: item, onDelete: {
                            viewModel.deleteItem(at: viewModel.items.firstIndex(where: { $0.id == item.id })!)
                        })
                            .padding(.horizontal)
                    }
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
                    presentationMode.wrappedValue.dismiss()
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
            SelectExerciseView(viewModel: viewModel)
        }
        // dismiss view if workout created successfully
        .onReceive(viewModel.$didUploadWorkout) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
