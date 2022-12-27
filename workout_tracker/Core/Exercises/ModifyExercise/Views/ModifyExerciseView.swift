//
//  ModifyExerciseView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct ModifyExerciseView: View {
    let modifyType: ModifyObjectMode
    @State private var showDeleteDialog = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ModifyExerciseViewModel
    @ObservedObject var parentViewModel: ExercisesViewModel
    
    // init for creating a new exercise
    init(parentViewModel: ExercisesViewModel, exercise: Exercise? = nil) {
        self.parentViewModel = parentViewModel
        
        if exercise == nil {
            self.modifyType = .add
            self.viewModel = ModifyExerciseViewModel()
        } else {
            self.modifyType = .edit
            self.viewModel = ModifyExerciseViewModel(exercise: exercise)
        }
    }
    
    // validate the form and enable the submit button
    var formValidated: Bool {
        !viewModel.name.isEmpty && (viewModel.includeReps || viewModel.includeTime || viewModel.includeWeight)
    }
    
    var body: some View {
        Form() {
            Section(header: Text("NAME (Required)")) {
                TextField("Exercise name", text: $viewModel.name)
            }
            
            Section(header: Text("CATEGORY/TYPE (OPTIONAL)")) {
                TextField("Exercise type, muscle group, etc.", text: $viewModel.type)
            }
            
            Section(header: Text("DETAILS (OPTIONAL)")) {
                TextField("Proper form, machine settings, etc.", text: $viewModel.details)
            }

            Section(header: Text("DATA FIELDS (select at least one)")) {
                Toggle(isOn: $viewModel.includeWeight) {
                    Text("Weight")
                }
                
                Toggle(isOn: $viewModel.includeReps) {
                    Text("# of Reps")
                }

                Toggle(isOn: $viewModel.includeTime) {
                    Text("Time")
                }
            }
            
            if modifyType == .edit {
                Section {
                    Button("Delete Exercise", role: .destructive) {
                        showDeleteDialog = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .alert("Delete this exercise?", isPresented: $showDeleteDialog) {
                        Button("Delete", role: .destructive) {
                            viewModel.deleteExercise()
                            parentViewModel.fetchExercises()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.name.isEmpty ? "Add Exercise" : viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }

            // submit button - only enable if form is validated
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.modifyExercise()
                    parentViewModel.fetchExercises()
                } label: {
                    Text(modifyType.submitText)
                }
                .disabled(!formValidated)
            }
        }
        // dismiss view if exercise created successfully
        .onReceive(viewModel.$didCreateExercise) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ModifyExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ModifyExerciseView(parentViewModel: ExercisesViewModel())
        }
        
        NavigationView {
            ModifyExerciseView(parentViewModel: ExercisesViewModel())
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
