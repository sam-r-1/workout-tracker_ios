//
//  ExcercisesView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/10/22.
//

import SwiftUI

struct ExercisesView: View {
    @State private var showModifyExerciseView = false
    @ObservedObject var viewModel = ExercisesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {

            AddNewHeaderView(title: "My Exercises",
                             showView: $showModifyExerciseView,
                             view: AnyView(ModifyExerciseView(parentViewModel: viewModel)))
            
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchableExercises) {exercise in
                        NavigationLink {
                            NavigationLazyView(ModifyExerciseView(parentViewModel: viewModel, exercise: exercise))
                        } label: {
                            ExerciseRowView(
                                exercise: exercise,
                                trailingIcon: AnyView(Image(systemName: "arrow.right").foregroundColor(.gray))
                            )
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
