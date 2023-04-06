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
    @State private var showErrorDialog = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @ObservedObject var parentViewModel: ExercisesView.ViewModel
    
    init(parentViewModel: ExercisesView.ViewModel, exercise: Exercise? = nil) {
        self.parentViewModel = parentViewModel
        
        if exercise == nil {
            self.modifyType = .add
            self._viewModel = StateObject(wrappedValue: ViewModel())
        } else {
            self.modifyType = .edit
            self._viewModel = StateObject(wrappedValue: ViewModel(exercise: exercise))
        }
    }
    
    // validate the form and enable the submit button
    var formValidated: Bool {
        !viewModel.name.isEmpty && (viewModel.includeReps || viewModel.includeTime || viewModel.includeWeight)
    }
    
    var body: some View {
        ZStack {
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
                                Task {
                                    await viewModel.deleteExercise()
                                }
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
                    .disabled(viewModel.modifyingState == .loading)
                }
                
                // submit button - only enable if form is validated
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.modifyExercise()
                        }
                    } label: {
                        Text(modifyType.submitText)
                    }
                    .disabled(!formValidated || viewModel.modifyingState == .loading)
                }
            }
            
            if viewModel.modifyingState == .loading {
                LoadingView(includeBorder: true).edgesIgnoringSafeArea(.all)
            }
        }
        .alert(isPresented: $showErrorDialog) {
            Alert(
                title: Text("Something went wrong."),
                message: Text("Please try again later.")
            )
        }
        
        .onReceive(viewModel.$modifyingState) { modifyingState in
            if modifyingState == .error {
                showErrorDialog = true
            }
        }
        
        // dismiss view if exercise created/modified/deleted successfully
        .onReceive(viewModel.$isEditingComplete) { isComplete in
            if isComplete {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ModifyExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ModifyExerciseView(parentViewModel: ExercisesView.ViewModel())
        }
        
        NavigationView {
            ModifyExerciseView(parentViewModel: ExercisesView.ViewModel())
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
