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
    @State private var includeReps = false
    @State private var includeTime = false
    @Environment(\.presentationMode) var presentationMode
    
    // validate the form and enable the submit button
    var formValidated: Bool {
        !name.isEmpty && (includeReps || includeTime)
    }
    
    var body: some View {
        Form() {
            Section(header: Text("NAME (Required)")) {
                TextField("Exercise name", text: $name)
            }
            
            Section(header: Text("CATEGORY/TYPE (OPTIONAL)")) {
                TextField("Exercise type, muscle group, etc.", text: $type)
            }

            Section(header: Text("DATA FIELDS (select at least one)")) {
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
                    print("DEBUG: Adding exercise to database..")
                } label: {
                    Text("Add")
                        .padding(.trailing, 12)
                }
                .disabled(!formValidated)
            }
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}
