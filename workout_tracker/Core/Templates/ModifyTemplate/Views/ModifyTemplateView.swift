//
//  ModifyTemplateView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import SwiftUI

struct ModifyTemplateView: View {
    let modifyMode: ModifyObjectMode
    @State private var showDeleteDialog = false
    @State private var showAddExercise = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ModifyTemplateViewModel
    
    init(template: Template? = nil) {
        if template == nil {
            self.modifyMode = .add
            self.viewModel = ModifyTemplateViewModel()
        } else {
            self.modifyMode = .edit
            self.viewModel = ModifyTemplateViewModel(template: template)
        }
    }
    
    // validate the form and enable the submit button
    var formValidated: Bool {
        !viewModel.name.isEmpty && !viewModel.exerciseList.isEmpty
    }
    
    var body: some View {
        Form() {
            Section(header: Text("NAME (Required)")) {
                TextField("Template name", text: $viewModel.name)
            }

            Section(header: Text("Exercises (add at least one)")) {
                ForEach(viewModel.exerciseList, id: \.self) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button(role: .destructive) {
                            viewModel.exerciseList.remove(at: viewModel.exerciseList.firstIndex(where: { $0.id == item.id })!)
                        } label: {
                            Image(systemName: "delete.left.fill")
                        }

                    }
                }
            }
            
            Button {
                showAddExercise.toggle()
            } label: {
                Text("Add Exercise")
                    .bold()
            }
            .foregroundColor(Color(.systemGreen))
            .frame(maxWidth: .infinity, alignment: .center)

            
            if modifyMode == .edit {
                Section {
                    Button("Delete Template", role: .destructive) {
                        showDeleteDialog = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .alert("Delete this template?", isPresented: $showDeleteDialog) {
                        Button("Delete", role: .destructive) {
                            viewModel.deleteTemplate()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.name.isEmpty ? "Add Template" : viewModel.name)
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
                    viewModel.modifyTemplate()
                } label: {
                    Text(modifyMode.submitText)
                        .padding(.trailing, 12)
                }
                .disabled(!formValidated)
            }
        }
        .fullScreenCover(isPresented: $showAddExercise) {
            SelectExerciseView { exerciseId in
                viewModel.addExercise(exerciseId)
            }
        }
        // dismiss view if exercise created successfully
        .onReceive(viewModel.$didCreateTemplate) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ModifyTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyTemplateView()
    }
}
