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
    let onAdd: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 12)

            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchableExercises) {exercise in
                        ExerciseRowView(
                            exercise: exercise,
                            trailingIcon: AnyView(
                                Button("Add") {
                                    onAdd(exercise.id!)
                                    presentationMode.wrappedValue.dismiss()
                                }
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
        SelectExerciseView { _ in
            //
        }
    }
}
