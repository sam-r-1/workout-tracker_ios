//
//  SelectExerciseView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/18/22.
//

import SwiftUI

struct SelectExerciseView: View {
    @StateObject var viewModel = SelectExerciseViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    let onAdd: (String) -> Void
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemGray6 : .black).edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                }
                
                Text("Select an Exercise")
                    .font(.title)
                    .bold()

                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 20)
                
                List {
                    ForEach(viewModel.searchableExercises) {exercise in
                        ExerciseRowView(
                            exercise,
                            trailingIcon: AnyView(
                                Button("Add") {
                                    onAdd(exercise.id!)
                                    presentationMode.wrappedValue.dismiss()
                                }
                                    .foregroundColor(Color(.systemBlue))
                            )
                        )
                    }
                }
            }
        }
    }
}

struct SelectExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExerciseView(viewModel: SelectExerciseViewModel(forPreview: true)) { _ in
            //
        }
    }
}
