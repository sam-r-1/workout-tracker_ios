//
//  ModifyTemplateView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 10/17/22.
//

import SwiftUI

struct ModifyTemplateView: View {
    let modifyMode: ModifyObjectMode
    @State private var editMode = EditMode.active
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
        VStack(alignment: .leading) {
            Text("NAME (Required)")
            TextField("Template name", text: $viewModel.name)
            
            Spacer()
            
            HStack {
                Text("Exercises")
                
                Spacer()
                
                Button {
                    showAddExercise.toggle()
                } label: {
                    Text("+ Add")
                        .bold()
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                }
                .foregroundColor(.white)
                .background(Color(.systemGreen))
                .clipShape(Capsule())

            }
            .padding(.horizontal)
            
            List {
                ForEach(viewModel.exerciseList, id: \.self) { item in
                    Text(item.name)
                }
                .onDelete(perform: viewModel.removeExercise)
                .onMove(perform: viewModel.moveExercise)
            }
            .listStyle(.plain)
            .environment(\.editMode, $editMode)
            
            if modifyMode == .edit {
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
        .navigationTitle(viewModel.name.isEmpty ? "New Template" : viewModel.name)
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
                    Text("Save")
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
        // dismiss view if template created successfully
        .onReceive(viewModel.$didCreateTemplate) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ModifyTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ModifyTemplateView()
        }
    }
}
