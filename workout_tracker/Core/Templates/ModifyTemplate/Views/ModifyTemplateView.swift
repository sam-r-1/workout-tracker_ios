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
        VStack {
            Form {
                Section("Name (Required)") {
                    TextField("Template name", text: $viewModel.name)
                }
                
                Section(header: exerciseSectionHeader) {
                    List {
                        ForEach(viewModel.exerciseList, id: \.self) { item in
                            Text(item.name)
                        }
                        .onDelete(perform: viewModel.removeExercise)
                        .onMove(perform: viewModel.moveExercise)
                    }
                }
                
                if modifyMode == .edit {
                    Button(role: .destructive) {
                        showDeleteDialog = true
                    } label: {
                        Text("Delete Template")
                            .bold()
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
            .environment(\.editMode, $editMode)
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

extension ModifyTemplateView {
    var exerciseSectionHeader: some View {
        HStack {
            Text("Exercises".uppercased())
                //.font(.subheadline)
                //.foregroundColor(Color(.systemGray2))
            
            Spacer()
            
            Button {
                showAddExercise.toggle()
            } label: {
                Text("+ Add")
                    .bold()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
            }
            .foregroundColor(.white)
            .background(Color(.systemGreen))
            .clipShape(Capsule())
            
        }
    }
}

struct ModifyTemplateView_Previews: PreviewProvider {
    static let previewTemplate = Template(uid: "username", name: "Preview Template", exerciseIdList: ["0", "1", "2", "3"], exerciseNameList: ["Chest Press", "Leg Press", "Deadlift", "Bench Press"])
    
    static var previews: some View {
        NavigationView {
            ModifyTemplateView(template: previewTemplate)
        }
        
    }
}
