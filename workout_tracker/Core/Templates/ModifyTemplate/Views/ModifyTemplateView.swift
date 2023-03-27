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
    @State private var showErrorDialog = false
    @State private var showAddExercise = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    
    init(template: Template? = nil) {
        if template == nil {
            self.modifyMode = .add
            self._viewModel = StateObject(wrappedValue: ViewModel())
        } else {
            self.modifyMode = .edit
            self._viewModel = StateObject(wrappedValue: ViewModel(template: template))
        }
    }
    
    // validate the form and enable the submit button
    var formValidated: Bool {
        !viewModel.name.isEmpty && !viewModel.exerciseList.isEmpty
    }
    
    var body: some View {
        ZStack {
            Form {
                Section("Name (Required)") {
                    TextField("Template name", text: $viewModel.name)
                }
                
                Section(header: exerciseSectionHeader) {
                    List {
                        ForEach(viewModel.exerciseList, id: \.self) { item in
                            Text(item.name)
                        }
                        .onDelete { indexSet in
                            viewModel.removeExercise(at: indexSet)
                        }
                        .onMove { origin, destination in
                            viewModel.moveExercise(from: origin, to: destination)
                        }
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
                            Task {
                                await viewModel.deleteTemplate()
                            }
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            
            if viewModel.modifyingState == .loading {
                LoadingView(includeBorder: true).edgesIgnoringSafeArea(.all)
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
                    Task {
                        await viewModel.modifyTemplate()
                    }
                } label: {
                    Text("Save")
                        .padding(.trailing, 12)
                }
                .disabled(!formValidated || viewModel.modifyingState == .loading)
            }
        }
        .fullScreenCover(isPresented: $showAddExercise) {
            SelectExerciseView { exerciseId in
                Task {
                    await viewModel.addExercise(exerciseId)
                }
            }
        }
        
        .alert(isPresented: $showErrorDialog) {
            Alert(
                title: Text("Something went wrong."),
                message: Text("Please try again later.")
            )
        }
        
        .onReceive(viewModel.$modifyingState, perform: { modifyingState in
            if modifyingState == .error {
                showErrorDialog = true
            }
        })
        
        .onReceive(viewModel.$isEditingComplete) { isComplete in
            if isComplete {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension ModifyTemplateView {
    var exerciseSectionHeader: some View {
        HStack {
            Text("Exercises".uppercased())
            
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
