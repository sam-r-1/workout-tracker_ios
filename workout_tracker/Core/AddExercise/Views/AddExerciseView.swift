//
//  AddExerciseView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct AddExerciseView: View {
    @State private var name = ""
    @State private var type = ""
    @State private var details = ""
    @State private var includeWeight = false
    @State private var includeReps = false
    @State private var includeTime = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = AddExerciseViewModel()
    
    // validate the form and enable the submit button
    var formValidated: Bool {
        !name.isEmpty && (includeReps || includeTime || includeWeight)
    }
    
    var body: some View {
        Form() {
            Section(header: Text("NAME (Required)")) {
                TextField("Exercise name", text: $name)
            }
            
            Section(header: Text("CATEGORY/TYPE (OPTIONAL)")) {
                TextField("Exercise type, muscle group, etc.", text: $type)
            }
            
            Section(header: Text("DETAILS (OPTIONAL)")) {
                TextField("Proper form, machine settings, etc.", text: $details)
            }

            Section(header: Text("DATA FIELDS (select at least one)")) {
                Toggle(isOn: $includeWeight) {
                    Text("Weight")
                }
                
                Toggle(isOn: $includeReps) {
                    Text("# of Reps")
                }

                Toggle(isOn: $includeTime) {
                    Text("Time")
                }
            }
        }
        .navigationTitle(name.isEmpty ? "Add Exercise" : name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .padding(.leading, 12)
                }
            }

            // submit button - only enable if form is validated
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.createExercise(name: name, type: type, details: details, includeWeight: includeWeight, includeReps: includeReps, includeTime: includeTime)
                } label: {
                    Text("Add")
                        .padding(.trailing, 12)
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

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}
